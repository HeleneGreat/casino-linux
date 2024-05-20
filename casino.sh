#!/bin/bash

declare -i cagnotte=100

# Le montant visé pour gagner le jeu du casino
declare -i pari

# La mise du joueur pour un jeu
declare -i mise

# Couleurs
declare neutre='\e[0;m'
declare vert='\e[0;32m'
declare rouge='\e[0;31m'
declare rouge_gras='\e[1;31m'
declare jaune='\e[1;33m'
declare cyan='\e[1;36m'

# Initialisation du jeu de casino
function init_game(){
    clear
    echo -e "${rouge_gras}*************************************"
    echo -e "**** BIENVENUE AU CASINO DU MDS *****"
    echo -e "*************************************${neutre}"
    echo -e "Vous disposez d'une cagnotte d'une valeur de ${jaune}$cagnotte€${neutre}."
    choixPari
}

# Le joueur choisi le montant de son pari
function choixPari(){
    echo "Quel montant pensez-vous pouvoir atteindre ? (minimum 500€)"
    read pari
    if [[ "$pari" =~ ^[0-9]+$ && "$pari" -ge 500 ]];then
        echo -e "Vous devrez donc atteindre un gain de ${rouge_gras}$pari€${neutre} pour remporter ce jeu"
        sleep 2
        choixJeu
    else 
        echo "Vous devez choisir un montant supérieur ou égal à 500€"
        choixPari
    fi
}

# Afficher la cagnotte du joueur
function cagnotte(){
    clear
    echo -e "${jaune}*************************************"
    echo -e "********* CAGNOTTE : $cagnotte € **********"
    echo -e "**** ${rouge}Pari à atteindre : ${rouge_gras}$pari € ${jaune}*****"
    echo -e "*************************************${neutre}"
    verify_victory
}

# Vérifier si la cagnotte du joueur a atteint le montant de son pari
function verify_victory(){
    if [ $cagnotte -ge $pari ];then
        clear
        echo -e "${vert}************************************************"
        echo -e "*************** Félicitations !! ***************"
        echo -e "******* Vous avez remporter votre pari ! *******"
        echo -e "********* ${jaune}cagnotte : $cagnotte€${vert} | ${rouge_gras}pari : $pari€${vert} *********"
        echo -e "************************************************${neutre}"
       rejouer
    elif [ $cagnotte -eq 0 ];then
        clear
        echo -e "${rouge}************************************************"
        echo -e "***************** GAME OVER ! *****************"
        echo -e "******* Vous avez épuisé votre cagnotte *******"
        echo -e "********* ${jaune}cagnotte : $cagnotte€${rouge} | ${rouge_gras}pari : $pari€${rouge} *********"
        echo -e "************************************************${neutre}"
       rejouer
    fi
}

# Demande au joueur s'il souhaite rejouer
function rejouer(){
    echo "Souhaitez-vous rejouer au Casino du MDS ?"
    select rejouer in "Oui" "Non"
    do
        if [ $REPLY -eq 1 ];then
            init_game
        else
            quit
        fi
        break
    done
}

# Le joueur choisit parmi 3 jeux disponibles
function choixJeu(){
    if [ "$cagnotte" -gt 0 ];then
        cagnotte
        echo "A quel jeu souhaitez-vous jouer ?"
        select jeu in "Pile ou Face" "La machine à sous" "Pierre Feuille Ciseaux" "Quitter le Casino du MDS"
        do
            case $REPLY in
                1 ) pileOuFace ;;
                2 ) machineASous ;;
                3 ) pierreFeuilleCiseaux ;;
                4 ) quit ;;
                * ) echo -e "${rouge_gras}Choix incorrect${neutre}"
                    choixJeu ;;
            esac
            break
        done
    else 
        verify_victory
    fi
}

# Initialise le jeu de pile ou face
function pileOuFace(){
    clear
    echo -e "${cyan}************************************************"
    echo -e "****************** Pile ou Face ******************"
    echo -e "********* ${jaune}cagnotte : $cagnotte€${cyan} | ${rouge_gras}pari : $pari€${cyan} *********"
    echo -e "************************************************${neutre}"
    miser
    echo "Souhaitez-vous parier sur pile ou face ?"
    result=$(( $RANDOM % 2 + 1 ))
    select choix in "Pile" "Face"
    do
        if [ "$REPLY" = "$result" ];then
            let "cagnotte+=$mise*2"
            echo -e "${vert}Bravo ! Vous avez remporté votre mise."
            echo -e "Votre cagnotte s'élève à ${jaune}$cagnotte€${neutre}"
        else
            let "cagnotte-=$mise"
            echo -e "${rouge_gras}Perdu ! Vous avez perdu votre mise."
            echo -e "Votre cagnotte s'élève à ${jaune}$cagnotte€${neutre}"
        fi
        break
    done
    # Vérifie si le joueur à remporté son pari
    if [ $cagnotte -ge $pari ];then
        verify_victory
    else
        echo "Que souhaitez-vous faire ?"
        select jeu in "Rejouer à Pile ou Face" "Sélectionner un autre jeu"
        do
            case $REPLY in
                1) pileOuFace ;;
                2) choixJeu ;;
                *) echo -e "${rouge_gras}Choix incorrect${neutre}"
                choixJeu ;;
            esac
            break
        done
    fi
}

# TODO
# Initialise le jeu de la machine à sous
function machineASous(){
    clear
    echo -e "${cyan}************************************************"
    echo -e "**************** La machine à sous ****************"
    echo -e "********* ${jaune}cagnotte : $cagnotte€${cyan} | ${rouge_gras}pari : $pari€${cyan} *********"
    echo -e "************************************************${neutre}"
    miser
    echo "Le but du jeu est d'aligner le plus de symbôles identiques possibles"
    echo "Voici les gains possibles :"
    echo "&& : aucun gain ni perte"
    echo "++ : aucun gain ni perte"
    echo "%% : aucun gain ni perte"
    echo "## : aucun gain ni perte"
    echo -e "${vert}"'$$ : la mise de départ est doublée'
    echo -e "&&& : la mise de départ est doublée"
    echo -e "+++ : la mise de départ est doublée"
    echo -e "%%% : la mise de départ est doublée"
    echo -e "### : la mise de départ est doublée"
    echo -e '$$$$ : la mise de départ est triplée !'
    echo -e "${rouge_gras}Toutes les autres combinaisons entraîne la perte de la mise${neutre}"
}

# Initialise le jeu de pierre feuille ciseaux
function pierreFeuilleCiseaux(){
    clear
    echo -e "${cyan}************************************************"
    echo -e "********** Pierre / Feuilles / Ciseaux **********"
    echo -e "********* ${jaune}cagnotte : $cagnotte€${cyan} | ${rouge_gras}pari : $pari€${cyan} *********"
    echo -e "************************************************${neutre}"
    miser
    echo "Souhaitez-vous jouer avec Papier, Feuille ou Ciseaux ?"
    random=$(( $RANDOM % 3 + 1 ))
    select choix in "Papier" "Feuille" "Ciseaux"
    do
        echo "Votre choix : $choix"
        # Analyse des résultats
            # Egalité
        if [ "$REPLY" = "$random" ];then
            echo -e "${cyan}Egalité ! Vous devez rejouer${neutre}"
            sleep 2
            pierreFeuilleCiseaux
            # Si l'ordinateur a choisi "Pierre"
        elif [ "$random" = "1" ];then
            case $REPLY in
                # Feuille = gagné
                2) let "cagnotte+=$mise*2"
                echo -e "${cyan}Bravo ! Vous avez gagné.${neutre}"
                echo -e "Votre cagnotte s'élève à ${jaune}$cagnotte€${neutre}";;
                # Ciseaux = perdu
                3) let "cagnotte-=$mise"
                echo -e "${rouge_gras}Perdu ! Vous avez perdu votre mise."
                echo -e "Votre cagnotte s'élève à ${jaune}$cagnotte€${neutre}";;
            esac
            # Si l'ordinateur a choisi "Feuille"
        elif [ "$random" = "2" ];then
            case $REPLY in
                # Pierre = perdu
                1) let "cagnotte-=$mise"
                echo -e "${rouge_gras}Perdu ! Vous avez perdu votre mise."
                echo -e "Votre cagnotte s'élève à ${jaune}$cagnotte€${neutre}";;
                # Ciseaux = gagné
                3) let "cagnotte+=$mise*2"
                echo -e "${cyan}Bravo ! Vous avez gagné.${neutre}"
                echo -e "Votre cagnotte s'élève à ${jaune}$cagnotte€${neutre}";;
            esac
            # Si l'ordinateur a choisi "Ciseaux"
        else
            case $REPLY in
                # Pierre = gagné
                1) let "cagnotte+=$mise*2"
                echo -e "${cyan}Bravo ! Vous avez gagné.${neutre}"
                echo -e "Votre cagnotte s'élève à ${jaune}$cagnotte€${neutre}";;
                # Feuille = perdu
                2) let "cagnotte-=$mise"
                echo -e "${rouge_gras}Perdu ! Vous avez perdu votre mise."
                echo -e "Votre cagnotte s'élève à ${jaune}$cagnotte€${neutre}";;
            esac
        fi
        break
    done
    # Vérifie si le joueur à remporté son pari
    if [ $cagnotte -ge $pari ];then
        verify_victory
    else
        echo "Que souhaitez-vous faire ?"
        select jeu in "Rejouer à Pierre / Feuille / Ciseaux" "Sélectionner un autre jeu"
        do
            case $REPLY in
                1) pierreFeuilleCiseaux ;;
                2) choixJeu ;;
                *) echo -e "${rouge_gras}Choix incorrect${neutre}"
                choixJeu ;;
            esac
            break
        done
    fi
}

# Choix d'une mise pour chaque jeu
function miser(){
    echo "Combien souhaitez-vous miser pour ce jeu ?"
    read mise
    if [[ "$mise" =~ ^[0-9]+$ && "$mise" -le "$cagnotte" ]];then
        echo -e "Vous avez choisi de parier ${cyan}$mise€${neutre}. Que la chance soit avec vous !"
    else
        echo -e "Votre mise est incorrecte. Elle doit être inférieure au montant de votre cagnotte (${jaune}$cagnotte€${neutre})"
        miser
    fi
}

# Quitter le jeu du casino
function quit(){
    clear
    echo -e "${rouge_gras}**********************************************"
    echo -e "******************* A BIENTOT *******************"
    echo -e "*************** au Casino du MDS ***************"
    echo -e "**********************************************${neutre}"
}

init_game
