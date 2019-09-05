//
//  Notes.swift
//  Boursobook
//
//  Created by David Dubez on 13/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

// TODO:    - A faire :
/*
            - Voir comment on fait une config en localisation France sans faire de Target differentes ???
 
            - Simpliffier les fonctionnalités non necessaires pour la soutenance
            - Verifier la generation de la page des QRCode
            - ajouter titre et ISBN sur le QR Code
 
            - Probleme de stop listen
            - Arreter la syncchro des bases quand l'app n'est plus active et la remttre quand elle arrive
                (est ce que j'arrete la syncho sur chaque VC? )
            - corriger sold par sold
            - voir ce qui se passe si pas de reseau et pas d'acces ???
            - Verifier le bon coverage des tests
            - test et dependance de la classe UserService
            - verifier avec l'affichage en IPhone 4S si pas erreur
            - test en release si la base prod fonctionne
            - Supprimer le fichier Notes
//          - Supprimer tous les messages d'alertes dans la console
*/

// MARK: - A voir avec Vincent
/*
 - Comment je peux tester la classe inMemoryStorage (dependance ??) est ce que les fonctions
 ne sont pas redondantes avec purseAPI ?? Est ce que cette classe est utille
ou je peux faire les implementataion directement dans les VC?
 - Dans FireBaseRequest ligne 35 : je sors de la fonction si je trouve un seul element que je n'arrive pas à
 initialiser ?? meilleure methode ??
 - difference entre callBack et completionHandler ?
 - La DB est free pour un certain montant. Comment je fais si il
 y a plus de connexion ? Je valide l'acces par mail, je facture le
 compte ??  Je fais payer su l'app store un montant en fonction
 de la limite de la base ??
 

 */

// MARK: - UserService
/*
 - verifier qu'on cree pas 2 fois la meme instance (meme purse ....)
 - Ajouter l'user crée dans la purse en cours (id et mail)
 
 */

// MARK: - Seller
/*
 - calcul des articles à vendre et vendus
 - probleme de la fonction nextnumber si on supprime des articles et qu'on en crée d'autre après
 - Mettre les zero dans le numero d'ordre
 
 */

// MARK: - SellerService
/*
 - gestion erreur dans increase number of article et number of order
 
 */

// MARK: - InMemoryStorage
/*
 - gestion de l'appli offligne
 - valider l'entrée dans l'appli meme s'il n'y a pas de seller, de article ou de transactions
 
 */

// MARK: - AddNewSellerVC
/*
 - Controle du format correct du tel et du mail
 
 */
// MARK: - SellersListVC
/*
 - Voir pourquoi le unwind segue ne fonctionne pas lorsque j'efface l'utilisateur loggé
 
 */
// MARK: - scanningVC
/*
 - Gerer optionnel videoPreviewLayer ???
 - Voir probleme affichage de la camera
 - faire implementation pour ajouter un article manuellement
 
 */

// MARK: - SellerVC
/*
 - Mettre la posibilité de modifier les informations des vendeurs
 - Imprimer la liste des articles vendus et restants PDF
 avec les prix de ventes / montants revenants au vendeur
 - Calculer forfait d'insription en fonction du nombre d'article
 ( et creer une vente fictive pour enregister transaction
 - #### Mettre a jour le montant de desposit fee dans la purse #####
 - Mettre les chiffres au format
 - Traiter la partie pour la restitution des livres
 - Améliorer la résolution des QRCODE et la position des ecritures sur les etiquettes (et taille avec des mm)
 - tester generation plusieurs pages d'étiquettes
 
 */

// MARK: - ArticleListTableVC
/*
  faire une tri des article suivant leur type
 - afficher que les articles qui ne sont pas vendus
 - gerer le format du prix
 - Revoir la mise en forme de la cellule
 
 */

// MARK: - AddArticleVC
/*
 - Gerer le format du prix / et celui de l'isbn
 - probleme avec certain livre error in JSONDECODER
 
 */

// MARK: - SetupVC
/*
 - Ajouter le reglage pour la page d'impression
 - Verouiller l'acces aux régalges si c'est pas delphine ????
 - Mettre des valuers avec virgules pour voir si le format passe`
 - metter une verification au max à 100% sur le pourcentage
 - attention a la gestion du clavier (ne cache pas les textes)
 - implementer la fonction "add new user" pour donner l'autorisation
 a un utilisateur inscrit d'acceder à la purse
 
 */

// MARK: - InfoVC
/*
 - Ajouter un bouton pour acces liste transaction
 - Ajouter bouton liste articles totaux
 - Ajouter un contact pour mailing list
 - Afficher qu'un email a bien été envoye à l'emeil du la création
 
 */

// MARK: - LoginVC
/*
 - faire disparaitre le login si on est déja logé
 - Gestion des mots de passe et des fonction save et login
 - gestion de l'appli offligne
 - message si on est pas connecté et que l'on peut pas telecharger les données
 - verifier toutes les tailles d'iphones
 - Mettre à jour les string du storyboard
 - separer les storyboard
 
 */

// MARK: - BuyVC
/*
 - Probleme montant calculer sur la part de l'APE
 
 */

// MARK: - VC
/*
 -
 
 */
