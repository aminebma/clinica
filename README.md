# Clinica
## Description
Clinica est une application mobile de e-santé qui permet à des patients de demander des conseils médicaux en ligne.

# Fonctionnalités
## Fonctionnalités des patients
### Création de compte
Un patient peut créer un compte en remplissant un formulaire dans lequel il devra fournir:
- Nom
- Prénom
- Adresse
- Numéro de téléphone
- E-mail

Une fois le formulaire remplit, un mot de passe à 4 chiffres sera envoyé au patient par sms afin de pouvoir se connecter à l'avenir.

### Authentification
L'authentification à l'application se fait en utilisant le numéro de téléphone et le mot de passe envoyé par sms.

### Affichage des médecins
La page d'accueil affiche la liste des médecins disponibles dans l'application avec l'ensemble de leurs informations:
- Nom & Prénom du médecin
- Photo 
- Spécialité
- Numéro de téléphone

L'utilisateur aura également la possibilité de filtrer cette liste par spécialité des médecins.

### Demande de conseil médical
Le patient peut demander un conseil médical auprès d'un médecin en utilisant trois sections:
1. Section 1 (Obligatoire): Utilisée pour mentionner les symptômes de sa maladie en les sélectionnant à partir d'une liste de symptômes fréquents. Le patient a aussi la possibilité de saisir un texte libre pour décrire d'autres symptômes
2. Section 2 (Optionnelle): Utilisée pour mentionner les traitements en cours pris par le patients avec un texte libre
3. Section 3 (Optionnelle): Utilisée pour joindre une photo liée à sa maladie

En cas d'indisponibilité de connexion à internet, la demande sera sauvegardée en local et sera alors envoyée dès que la connexion sera disponible.

## Fonctionnalités des médecins
### Compte et Authentification
Les médecins doivent contacter l'équipe de développement pour pouvoir avoir un compte, et se connecteront en utilisant leur numéro de téléphone et le mot de passe qui leur sera attribué.

### Affichage et traitement des demandes
La page d'accueil du médecin lui affiche les demandes non-traitées qui lui ont été envoyée. Il lui suffira de sélectionner une demande pour saisir le conseil qu'il enverra au patient.
Une notification push sera alors envoyée au patient pour l'informer de la réponse du médecin.

### Tableau de bord 
Chaque médecin dispose d'un tableau de bord qui lui affichera les indicateurs suivants:
- Nombre de demandes du jour en cours
- Nombre de demandes traités du jour en cours
- Évolution journalière du nombre de demandes (entre J et J-1)

# Déploiement
## Installation
Pour déployer le serveur, clonez le repository au sein de votre machine (Positionnez-vous dans le dossier où vous souhaitez cloner le repository)
```git
git clone https://www.github.com/aminebma/clinica.git
```
Téléchargez ensuite les packages Node.js nécéssaires
```bash
npm i
``` 
Une fois que vous aurez fais cela, vous aurez besoin de créer une base de données MongoDB, le nom par défaut doit être db-clinica, mais vous pouvez modifier cela dans les fichiers du dossier "config/".

##Initialisation des variables d'environnement
Le serveur utilise des variables d'environnement afin d'assurer une meilleure sécurité des secrets. 
Ces variables sont:
1. Nom d'utilisateur de l'administrateur de la base de données: clinica_admin_username
2. Mot de passe de l'administrateur de la base de données: clinica_admin_password
3. SID du compte Twilio (Il faudra créer un compte [Twilio](www.twilio.com)): clinica_twilio_accountSid
4. Le token d'authentification Twilio: clinica_twilio_authToken
5. L'environnement dans lequel vous déployez ce serveur, peut prendre les valeurs:
    - deveploment
    - production
6. L'addresse ip du serveur: clinica_server_ip
7. Le port d'écoute: clinica_server_port

(Si aucune valeur n'est spécifiée, l'environnement de développement sera considéré).

Sur windows:
```bash
set clinica_admin_username = votreUsernameAdmin
set clinica_admin_password = votreMotDepasseAdmin
set clinica_twilio_accountSid = votreAccountSid
set clinica_twilio_authToken= votreAuthToken
set NODE_ENV = votreEnvironnement
set clinica_server_ip = ip.de.votre.server
set clinica_server_port = votrePort
```
Sur Linux/Mac
```bash
export clinica_admin_username = votreUsernameAdmin
export clinica_admin_password = votreMotDepasseAdmin
export clinica_twilio_accountSid = votreAccountSid
export clinica_twilio_authToken= votreAuthToken
export NODE_ENV = votreEnvironnement
export clinica_server_ip = ip.de.votre.server
export clinica_server_port = votrePort
```

## Lancement du serveur
Pour lancer le serveur, il suffit d'exécuter la commande suivante
```bash
node app.js
```

## Exécuter les tests
Pour exécuter les tests, lancez la commande 
```bash
npm run test
```

# Contacts   
- Mohamed Amine BENBAKHTA: 
    - [gm_benbakhta@esi.dz](mailto:gm_benbakhta@esi.dz)
    - [LinkedIn](https://www.linkedin.com/in/mohamed-amine-benbakhta)    
- Lotfi Rdjem DARSOUNI: 
    - [gl_darsouni@esi.dz](mailto:gl_darsouni@esi.dz) 
    - [LinkedIn](https://www.linkedin.com/in/lotfi-rdjem-darsouni-250747176)   
- Younes MORSI: 
    - [gy_morsi@esi.dz](mailto:gy_morsi@esi.dz)
    - [LinkedIn](https://www.linkedin.com/in/younes-morsi-35722a188)
