[#import "macros/head.ftl" as headUtil]
[#import "macros/footer.ftl" as footerUtil]

[#import "macros/navigation.ftl" as navigationUtil]

<!DOCTYPE html>
<html lang="nl">

    [@headUtil.head title='hello' /]

    <body class="home">

        <div class="home-navigation">
            <a href="/about" class="home-navigation-link bg-greybat">
                <span class='h2 c-white home-navigation-link-title' href="/about">poelregels</span>
            </a>
            <a href="/form" class="home-navigation-link bg-green">
                <span class='h2 c-white home-navigation-link-title' >poel invullen</span>
            </a>
            <a href="/ranking" class="home-navigation-link bg-darkgreen">
                <span class='h2 c-white home-navigation-link-title' >poelstand</span>
            </a>
        </div>

        [@footerUtil.footer /]
    </body>
</html>