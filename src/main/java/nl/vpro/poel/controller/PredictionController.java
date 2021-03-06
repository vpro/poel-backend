package nl.vpro.poel.controller;

import nl.vpro.poel.UserUtil;
import nl.vpro.poel.domain.*;
import nl.vpro.poel.dto.PredictionForm;
import nl.vpro.poel.dto.ScoredPrediction;
import nl.vpro.poel.exception.MultiplierException;
import nl.vpro.poel.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Controller
@RequestMapping(value = "/predictions")
class PredictionController {

    private final MatchService matchService;

    private final BonusService bonusService;
    private final BonusChoiceService bonusChoiceService;

    private final PredictionService predictionService;

    private final ScoreService scoreService;

    @Autowired
    public PredictionController(MatchService matchService, BonusService bonusService, BonusChoiceService bonusChoiceService, PredictionService predictionService, ScoreService scoreService) {
        this.matchService = matchService;
        this.bonusService = bonusService;
        this.bonusChoiceService = bonusChoiceService;
        this.predictionService = predictionService;
        this.scoreService = scoreService;
    }

    @RequestMapping(method = RequestMethod.GET)
    String showForm(Principal principal, Model model) {

        CurrentUser currentUser = UserUtil.getCurrentUser(principal)
                .orElseThrow(() -> new RuntimeException("No user?!"));

        User user = currentUser.getUser();

        List<BonusChoice> countryChoices = bonusChoiceService.choicesFor(BonusCategory.COUNTRY);
        List<BonusChoice> playerChoices = bonusChoiceService.choicesFor(BonusCategory.PLAYER);
        List<BonusChoice> scoreChoices = bonusChoiceService.choicesFor(BonusCategory.SCORE);

        model.addAttribute("countries", countryChoices);
        model.addAttribute("players", playerChoices);
        model.addAttribute("scores", scoreChoices);

        Instant now = Instant.now();

        List<ScoredPrediction> finished = toScoredPredictions(matchService.findAllCompleted(), bonusService.findAllCompleted(), user);
        List<ScoredPrediction> unfinished = toScoredPredictions(matchService.findAllUnfinished(now), bonusService.findAllUnfinished(now), user);
        List<ScoredPrediction> future = toScoredPredictions(matchService.findMatchesToPredict(now), bonusService.findBonusesToPredict(now), user);

        model.addAttribute("finished", finished);
        model.addAttribute("unfinished", unfinished);
        model.addAttribute("future", future);

        return "predictions";
    }

    @RequestMapping(method = RequestMethod.POST)
    String savePredictions(Principal principal, @ModelAttribute("predictions") PredictionForm predictions, BindingResult bindingResult, RedirectAttributes redirectAttributes) {
        Instant submittedAt = Instant.now();
        User user = UserUtil.getCurrentUser(principal).orElseThrow(() -> new RuntimeException("No user?!")).getUser();
        try {
            int updates = predictionService.save(user, predictions, submittedAt);
            redirectAttributes.addFlashAttribute("flash", updates + " voorspelling" + (updates != 1 ? "en" : "") + " opgeslagen");
        } catch (MultiplierException e) {
            redirectAttributes.addFlashAttribute("flash", e.getMessage());
        }

        return "redirect:/predictions";
    }

    private List<ScoredPrediction> toScoredPredictions(List<Match> matches, List<Bonus> bonuses, User user) {
        return Stream.concat(
                matches.stream()
                        .map(match -> predictionService.getPredictionForMatch(user, match)
                                .orElseGet(() -> new Prediction(user, match))),
                bonuses.stream()
                        .map(bonus -> predictionService.getPredictionForBonus(user, bonus)
                                .orElseGet(() -> new Prediction(user, bonus)))
                )
                .sorted((p1, p2) -> p1.getStart().compareTo(p2.getStart()))
                .map(prediction -> new ScoredPrediction(prediction, scoreService.getScore(prediction)))
                .collect(Collectors.toList());
    }
}
