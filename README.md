# Ramaca in Chiaro · versione cloud privata

## Struttura

- `public/`: interfaccia pubblica senza movimenti né saldi reali.
- `supabase/migrations/202610150001_init.sql`: tabelle e regole RLS.
- `.github/workflows/deploy.yml`: pubblicazione GitHub Pages.
- Il file storico `outputs/ramaca-private-import/transactions.json` è tenuto fuori da questa cartella e non va caricato su GitHub.

GitHub Pages serve solo codice statico. Login e database sono affidati a Supabase Auth e Postgres. Le tabelle rifiutano le richieste anonime e ogni riga è filtrata sull'utente autenticato. La chiave publishable nel client è pubblica per progetto; non inserire mai una chiave `service_role` o `sb_secret` nel browser o nel repository.

## Attivazione dei servizi

1. Crea un progetto Supabase e apri **SQL Editor**. Esegui tutto il file `supabase/migrations/202610150001_init.sql`.
2. In **Authentication → Users**, crea l'utente con l'indirizzo email con cui accederai e imposta la password. L'app non offre registrazione pubblica.
3. In **Project Settings → API Keys** copia il Project URL e la chiave **publishable** (`sb_publishable_…`; nei progetti precedenti può essere la chiave anon).
4. Crea un repository GitHub nuovo e carica solo i contenuti di questa cartella. Questa cartella non contiene i movimenti storici. Non caricare la cartella superiore `outputs`.
5. Nelle impostazioni del repository GitHub aggiungi le variabili Actions `SUPABASE_URL` e `SUPABASE_PUBLISHABLE_KEY` con i valori ottenuti da Supabase. Sono valori identificativi pubblici; la protezione dei dati è applicata da Auth e RLS.
6. In **Settings → Pages**, seleziona **GitHub Actions**. Il workflow pubblica l'app a ogni aggiornamento del ramo `main`.
7. Dopo la prima pubblicazione, aggiungi l'URL GitHub Pages tra gli URL del sito consentiti in Supabase Auth.
8. Apri la pagina, accedi e usa **Importa prima nota** per caricare il file privato `outputs/ramaca-private-import/transactions.json`. L'importazione salva 891 movimenti e i tre saldi iniziali nel database associato al tuo utente.

## Uso su iPhone e tablet

Apri l'indirizzo HTTPS GitHub Pages in Safari, accedi, poi usa **Condividi → Aggiungi alla schermata Home**. Su Android si può usare **Installa app** dal menu del browser. I dati vengono recuperati online da Supabase; la cache offline conserva icone e metadati, non le pagine con i movimenti.

## Limiti attuali

- Ogni utente autenticato vede solo i propri dati. Se vuoi aggiungere l'accesso a un commercialista o a un collaboratore, prima va definita la condivisione dei dati.
- Il file JSON storico è locale. Una volta importati, i dati vivono in Supabase e saranno disponibili ai dispositivi che accedono con lo stesso utente.
- Verifica nel pannello Supabase che l'indirizzo email sia confermato e usa una password robusta. Non inviare password, chiavi `service_role` o segreti GitHub in chat.
