[#import "../macros/head.ftl" as headUtil]
[#import "../macros/footer.ftl" as footerUtil]

[#import "../macros/navigation.ftl" as navigationUtil]

<!DOCTYPE html>
<html lang="nl">

    [@headUtil.head title='Admin'/]
    <body>

    [@navigationUtil.navigation title='Admin' back='users' /]
    <div class="grid bg-blue">
        <div class="grid-gutter">

            <h1 class="h4">Form for: ${ user.realName }</h1>

            Alleen admins zoals ${user.realName} (${user.username}/${user.role}) kunnen dit zien!

            [#list users]
                <h2>Alle deelnemers</h2>
                <ul>
                    [#items as u]
                        <li>${u.realName} (${u.username})</li>
                    [/#items]
                </ul>
            [#else]
                Er zijn geen deelnemers. :o(
            [/#list]

            <p>
                Todo: <br />
                Een export van emailadressen kunnen doen<br />
                Gebruikersgroepen kunnen aanmaken<br />
                Gebruikers in groepen kunnen toevoegen<br />
            </p>
        </div>
     </div>

    [@footerUtil.footer /]
    </body>
</html>
