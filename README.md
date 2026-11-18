# Weekschema

Persoonlijke week- en gezondheidsplanner: een kalender, dagtaken, stappen en metingen, de November-challenge, medicatie en supplementen, en notities.

## Opbouw
- **Eén bestand:** `index.html` (HTML, CSS en JavaScript), zonder build-stap. Netlify publiceert de root van de repo.
- **Opslag:** eerst `localStorage` (key `weekschema-YYYY-MM-DD`, de maandag van de week), daarna gesynchroniseerd met Supabase.
- **Supabase-project:** `weekschema` (https://wqtvntuvpydrzvcbfxbt.supabase.co). De publishable key staat in `index.html`; dat is veilig, want de beveiliging zit in RLS.
- **Tabel:** `public.weekschema_weeks` (`user_id`, `week` date, `payload` jsonb, `updated_at`), met één rij per gebruiker per week. Zie `supabase-setup.sql`.
- **Synchronisatie:** elke week-payload heeft een `_t`-tijdstempel. De nieuwste versie wint, of die nu lokaal staat of in de cloud. Er wordt gesynchroniseerd bij het inloggen en telkens als de app weer in beeld komt.
- **Inloggen:** e-mail en wachtwoord via Supabase Auth (`signInWithPassword`, `signUp`), met 'Wachtwoord vergeten?' (`resetPasswordForEmail`; de herstellink opent een formulier voor een nieuw wachtwoord). Werkt ook vanaf het iPhone-beginscherm.

## Schermen
- Onderin vier tabbladen: **Vandaag** (weekstrook, voortgangstegels, plan, gemeten, challenge, medicatie, notitie), **Week** (weektotalen, dagen, notities), **Maand** (kalender met stipjes en maandcijfers) en **Meer** (exporteren, importeren, week wissen, uitloggen).
- Stappen, eiwit en water bij 'Gemeten' vinken in november 2026 de bijbehorende challenge-doelen automatisch aan of uit.
- Water wordt opgeslagen als `gi wa` (liter).

## Keys in de payload (per week, dagindex i = 0 voor maandag t/m 6 voor zondag)
- `i-j`: taak j van dag i afgevinkt; `di-j`: aangepaste omschrijving van die taak
- `xi`: extra activiteiten `[{t, v}]`
- `gi{st,hk,hm,kc,ei}`: stappen, hardlopen in km, hardlooptijd in min, calorieën, eiwit
- `ci{fa,fr,al,st,ei,sl,wa,kr,gs}`: de challenge-vinkjes
- `mi{oe,pr}`, met `n` (aantal pompjes) en `t` (tijdstip); `mis0..3`: de supplementen
- `ni`: notitie van de dag

## Werkafspraken
- Haal altijd eerst de laatste versie op (`git pull`) voordat je iets wijzigt; er werken twee mensen aan.
- Wijzigingen aan de database als nieuw SQL-bestand toevoegen en uitvoeren in de Supabase SQL Editor.
