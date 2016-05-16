package nl.vpro.poel.controller;

import nl.vpro.poel.UserUtil;
import nl.vpro.poel.domain.*;
import nl.vpro.poel.dto.MatchAndPrediction;
import nl.vpro.poel.service.MatchService;
import nl.vpro.poel.service.PredictionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.security.Principal;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
class FormController {

    private final MatchService matchService;

    private final PredictionService predictionService;

    @Autowired
    public FormController(MatchService matchService, PredictionService predictionService) {
        this.matchService = matchService;
        this.predictionService = predictionService;
    }

    @RequestMapping(value = "/form", method = RequestMethod.GET)
    String showForm(Principal principal, Model model) {

        Optional<CurrentUser> user = UserUtil.getCurrentUser(principal);
        if (!user.isPresent()) {
            throw new RuntimeException("No user?!");
        }

        Instant now = Instant.now();

        List<MatchAndPrediction> finished = addUserPredictions(matchService.getAllCompletedMatches(), user);
        List<MatchAndPrediction> unfinished = addUserPredictions(matchService.getAllUnfinishedMatches(now), user);
        List<MatchAndPrediction> future = addUserPredictions(matchService.getMatchesToPredict(now), user);

        model.addAttribute("finished", finished);
        model.addAttribute("unfinished", unfinished);
        model.addAttribute("future", future);
        return "form";
    }

    // TODO: Move this logic out to a service?
    private List<MatchAndPrediction> addUserPredictions(List<Match> matches, Optional<CurrentUser> user) {
        return matches.stream()
                .map(match -> toMatchAndPrediction(user.get().getUser(), match))
                .collect(Collectors.toList());
    }

    private MatchAndPrediction toMatchAndPrediction(User user, Match match) {
        Optional<Prediction> prediction = predictionService.getPredictionForMatch(user, match);
        return new MatchAndPrediction(match, prediction.orElse(null));
    }

    @RequestMapping(value = "/form", method = RequestMethod.POST)
    String handleFormSubmit(@ModelAttribute("form") List<Prediction> form, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return "form";
        }
        // TODO
        return "redirect:/";
    }
}
