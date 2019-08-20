Attribute VB_Name = "Module5"
Option Explicit
Dim ws As Worksheet
Dim X As Integer
Dim l As Byte
Dim TabSheet() As Variant
Dim myText(15) As OLEObject

Function FichOuvert(F As String) As Boolean

On Error Resume Next
FichOuvert = Not Workbooks(F) Is Nothing

End Function

'Faire le retour du pr�t
Sub Retour_pret()

'd�claration des variables
Dim Trouve As Range, PlageDeRecherche As Range, NumLigne As Integer, numLigne2 As Integer
Dim Valeur_Cherchee As String, AdresseTrouvee As String
Dim derligne_tableau As Long
Dim valeur_B2 As Range
Dim Tableau(1 To 10) As String
Dim strMessage As String, Boucle As Integer
Dim PlageDeRecherchededonnees As Range
Dim Valeur_reCherchee As String, AdressereTrouvee As String
Dim N As Long
Dim ligne As String

'Pour faire des modifications il faut retirer la protection
ActiveSheet.Unprotect "spr"

Debut:
    Dim Fichier_Piece As String
    Dim chemin_piece As String
    Fichier_Piece = "PIECES GENERIQUE.xlsx"

    '____________________________________________________________________________________________________________________'
                'Tester l'entr�e des donn�es
                    
    'Tester si les cellules C3 (CM) et C4 (quantit�) sont vides
    'Or Range("C8") = "" Or Range("E6") = ""'
    If Range("C3") = "" Or Range("C4") = "" Then
        MsgBox ("Veuillez remplir le num�ro du CMS, la quantit� emprunt�e, le nom de l'emprunteur et l'observation")
        '? Range("E3").Select
        '? Range("E3").Copy
        '? Range("E3").Select
        '? Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        '?    :=False, Transpose:=False
        '? Range("E3").Select
        '? Range("E3") = "=IF(RC[-2]="""","""",VLOOKUP(RC[-2],Piece!C[-4]:C[-2],2,FALSE))"
        '? Application.CutCopyMode = False
        Worksheets("Retour_pret").Protect userinterfaceonly:=True, Password:="spr"
        Exit Sub
    Else
    End If
   
    'Tester si la cellule C3 (CMS) est un nombre et qu'il est compos� de 10 chiffres
    Dim CMS As String
    CMS = Range("C3").Value
    If Not IsNumeric(CMS) Then
        MsgBox ("Veuillez entrer un CMS compos� de 10 chiffres")
        Worksheets("Retour_pret").Protect userinterfaceonly:=True, Password:="spr"
        Exit Sub
    Else
        'D�finition de la variable
        Dim longueurCMS As Integer
        'Comptage des caract�res dans la cellule C3
        longueurCMS = Len(Range("C3").Value)
        
        'Test si la cellule contient 10 caract�res
        If longueurCMS <> 10 Then
            MsgBox ("Veuillez entrer un CMS compos� de 10 chiffres")
            Worksheets("Retour_pret").Protect userinterfaceonly:=True, Password:="spr"
            Exit Sub
        Else
        End If
        
        'Test si le CMS existe
        If IsError(Range("E3")) Then
                MsgBox ("Le CMS indiqu� n'existe pas")
                '? Range("E3") = "=IF(RC[-2]="""","""",VLOOKUP(RC[-2],Piece!C[-4]:C[-2],2,FALSE))"
                '? Range("C3").Select
                '? Application.CutCopyMode = False
                Worksheets("Retour_pret").Protect userinterfaceonly:=True, Password:="spr"
                Exit Sub
        Else
        
        End If
    End If

    'Tester si la cellule C4 (quantit�) est un nombre
    Dim Quantite As String
    Quantite = Range("C4").Value
    If Not IsNumeric(Quantite) Then
        MsgBox ("Veuillez entrer le nombre de pi�ce prise")
        Worksheets("Retour_pret").Protect userinterfaceonly:=True, Password:="spr"
        Exit Sub
    Else
    
    End If
    
    '____________________________________________________________________________________________________________________'
                'Message pour valider la cr�ation du bon de retour'
    
    If MsgBox("Etes-vous sur de vouloir cr�er le bon de retour de pr�t?", vbYesNo, "Demande de confirmation") = vbYes Then
    
    'Masquer les op�rations de la macro
     Application.ScreenUpdating = False
    
    'Variables pour les fichiers
    Dim retourPret As String, pret As String, chemin As String, tampon As String

    retourPret = "Retour_pret.xlsm"
    pret = "pret.xlsm"
    tampon = "Tampon.xlsm"

    Windows(retourPret).Activate
    chemin = Application.ActiveWorkbook.Path
    
    'Tester si le fichier "Tampon" est ouvert et l'ouvrir si n�cessaire
    If Not (FichOuvert(tampon)) Then
        'Workbooks.Open Filename:="T:\MSP\Boite_aux_lettres\Magasin\Nouvelle version\Tampon.xlsm"
        Workbooks.Open Filename:=chemin & "\" & tampon
    End If

    Windows("Tampon.xlsm").Activate
    ActiveSheet.Unprotect "spr"

    '____________________________________________________________________________________________________________________'
                'Cette macro permet de rechercher les CMS en doublon d�j� sorti en pr�t puis fait un filtre sur ceux ci'

    'Activer les fen�tres la fen�tre Pret'
    Windows("Retour_pret.xlsm").Activate
    Windows("Tampon.xlsm").Activate


    'Copier la cellule C3 (CMS)
    Windows("Retour_pret.xlsm").Activate
    Sheets("Retour_Pret").Select
    Range("C3").Select
    Range("C3").Copy
    
    'Coller la valeur dans la cellule Z1
    Windows("Tampon.xlsm").Activate
    Sheets("Pret").Select
    Range("Z1").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
        
    'Filtrer sur le CMS dans l'onglet "Pret"
    ActiveSheet.Range("$A$1:$X$895").AutoFilter Field:=3, Criteria1:= _
        Range("Z1")
    Range("A1").Select

    '____________________________________________________________________________________________________________________'
                'Cette macro permet de faire le filtre sur la colonne "type de retour" et "date"'
    
    Sheets("Pret").Select
    Set PlageDeRecherche = ActiveSheet.Columns(3) 'CMS
    ActiveSheet.Range("$A$1:$Z$974").AutoFilter Field:=13, Criteria1:="="   'Field -> Date Retour Mat�riel En Pr�t
    
    '____________________________________________________________________________________________________________________'
                'Comptage du nombre de lignes apr�s le filtre'
    
    Dim derlignes As Long
    
    Windows("Tampon.xlsm").Activate
    Sheets("Pret").Select

    Range("A1").Select
    derlignes = Cells(Rows.Count, 1).End(xlUp).Row 'Calcul de nombre de ligne dans le tableau
    Range("A1").Select
    
    If derlignes = 2 Then   'Sans doublon

        Windows("Retour_pret.xlsm").Activate
        Sheets("Retour_Pret").Select
        Range("C3").Select
        Valeur_Cherchee = Range("C3").Value 'R�cup�ration de la valeur de la cellule C3 dans la feuille "Retour_pret"
    
        Windows("Tampon.xlsm").Activate
        Sheets("Pret").Select
    
        'S�lectionne la plage de donn�es dans laquelle on cherche la valeur dans la colonne 3 (CMS) dans la feuille "Pret"
        Set PlageDeRecherche = ActiveSheet.Columns(3)
        'M�thode find, ici on cherche la valeur exacte (LookAt:=xlWhole)
        Set Trouve = PlageDeRecherche.Cells.Find(what:=Valeur_Cherchee, LookAt:=xlWhole)
       
        'traitement de l'erreur possible : Si on ne trouve rien :
        If Trouve Is Nothing Then
            
            'ici, traitement pour le cas o� la valeur n'est pas trouv�e'
            AdresseTrouvee = Valeur_Cherchee & " n'est pas pr�sent dans " & PlageDeRecherche.Address
        
        Else 'Si la valeur est trouv�e
            
            'Remplissage de la Date de Retour de Pr�t
            AdresseTrouvee = Trouve.Address
            numLigne2 = Trouve.Row
                
            Windows("Retour_pret.xlsm").Activate
            Sheets("Retour_Pret").Select
            Range("B2").Copy 'date
                
            Windows("Tampon.xlsm").Activate
            Sheets("Pret").Select
            
            'S�lectionne la ligne du CMS et la colonne M
            Range("M" & Trouve.Row).Select
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
                :=False, Transpose:=False

            'Remplissage du Type de Retour de Pr�t'
            Windows("Retour_pret.xlsm").Activate
            Sheets("Retour_Pret").Select
            Range("C8").Copy 'Type retour
            
            Windows("Tampon.xlsm").Activate
            Sheets("Pret").Select
                
            'S�lectionne la ligne du CMS et la colonne N'
            Range("N" & Trouve.Row).Select
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
                :=False, Transpose:=False
            
            Windows("Tampon.xlsm").Activate
            Sheets("Pret").Select
                
            Range("A1").Select
            'Effacer le filtre
            Selection.AutoFilter

            'Fermer le fichier "Trampon.xlsm" en sauvegardant
            Windows("Tampon.xlsm").Activate
            Workbooks("Tampon.xlsm").Close SaveChanges:=True

            'Effacer les donn�es des cellules
            Range("C3:C4,E6,C8").Select
            Selection.ClearContents
            Range("C3").Select
                
            Worksheets("Retour_pret").Protect userinterfaceonly:=True, Password:="spr"
            'Windows("Retour_pret.xlsm").Activate
            Workbooks("Retour_pret.xlsm").Close SaveChanges:=False

            Windows("pret.xlsm").Activate
            MsgBox ("La demande a bien �t� prise en compte")
            Exit Sub
            
        End If
    
    Else 'Avec doublon
        X = Range("A2:A" & derlignes).SpecialCells(xlCellTypeVisible).Count
    End If
    
    'Afficher les op�rations de la macro
    Application.ScreenUpdating = True

    '____________________________________________________________________________________________________________________'
                    'Cette macro permet de faire le test du nombre de doublon'
    
    If derlignes = 1 Then 'Test si le CMS n'est pas dans la liste
        
        Windows("Tampon.xlsm").Activate
        Sheets("Pret").Select
        
        Range("A1").Select
        'Effacer le filtre'
        Selection.AutoFilter
        
        Sheets("Pret").Select
        
        'Fermer le fichier "Tampon.xlsm" en sauvegardant
        Windows("Tampon.xlsm").Activate
        Workbooks("Tampon.xlsm").Close SaveChanges:=True

        'Effacer les donn�es des cellules
        Windows("Retour_pret.xlsm").Activate
        Sheets("Retour_Pret").Select
        Range("C3:C4,E6,C8").Select
        Selection.ClearContents
        Range("C3").Select
        
        Windows("Retour_pret.xlsm").Activate
        Sheets("Retour_Pret").Select
        
        MsgBox ("Le CMS que vous ramenez n'a pas �t� emprunt�, veuillez v�rifier le num�ro du CMS")
        
        Windows("Retour_pret.xlsm").Activate
        Sheets("Retour_Pret").Select
        
        Exit Sub
    Else
    End If

    '____________________________________________________________________________________________________________________'
                    'Test si le CMS apparait 1 fois'
    If X = 1 Then
    
        'Sheets("Pret").Select
        'Range("A1").Select
        Windows("Retour_pret.xlsm").Activate
        Sheets("Retour_Pret").Select
        Range("C3").Select
        Valeur_Cherchee = Range("C3").Value 'CMS
        
        Windows("Tampon.xlsm").Activate
        Sheets("Pret").Select
        
        'S�lectionne la plage de donn�es dans laquelle on cherche la valeur dans la colonne 3 (CMS) dans la feuille "Pret"
        Set PlageDeRecherche = ActiveSheet.Columns(3)
        'M�thode find, ici on cherche la valeur exacte (LookAt:=xlWhole)
        Set Trouve = PlageDeRecherche.Cells.Find(what:=Valeur_Cherchee, LookAt:=xlWhole)
    
        If Trouve Is Nothing Then 'traitement de l'erreur possible : Si on ne trouve rien
            
            AdresseTrouvee = Valeur_Cherchee & " n'est pas pr�sent dans " & PlageDeRecherche.Address
        
        Else 'Traitement pour le cas o� la valeur est trouv�e
            
            'Remplissage de la Date de Retour de Pr�t'
            AdresseTrouvee = Trouve.Address
            numLigne2 = Trouve.Row
            
            Windows("Retour_pret.xlsm").Activate
            Sheets("Retour_Pret").Select
            Range("B2").Copy 'date
                
            Windows("Tampon.xlsm").Activate
            Sheets("Pret").Select
                
            'S�lectionne la ligne du CMS et la colonne M (Date de Retour Mat�ril En Pr�t
            Range("M" & Trouve.Row).Select
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
                :=False, Transpose:=False

            'Remplissage du Type de Retour de Pr�t'
            Windows("Retour_pret.xlsm").Activate
            Sheets("Retour_Pret").Select
            Range("C8").Copy
            
            Windows("Tampon.xlsm").Activate
            Sheets("Pret").Select
                
            'S�lectionne la ligne du CMS et la colonne N (Type Retour)
            Range("N" & Trouve.Row).Select
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
                :=False, Transpose:=False
            
            
            Windows("Tampon.xlsm").Activate
            Sheets("Pret").Select
            Range("A1").Select
            'Effacer le filtre
            Selection.AutoFilter
            
            MsgBox ("La demande a bien �t� prise en compte!")

            'Masquer les op�rations de la macro
            Application.ScreenUpdating = False
                
            End If
    
    Else 'S'il y a plusieurs fois le CMS
    
    '____________________________________________________________________________________________________________________'
                    'Cr�ation d'un onglet "Doublon avec les doublons"
        
        Sheets("Pret").Select
        derligne_tableau = Cells(Rows.Count, 1).End(xlUp).Row 'Calcul de nombre de ligne dans le tableau
        Sheets.Add.Move After:=Sheets(Sheets.Count) 'Ajout d'une nouvelle feuille dans le classeur
        ActiveSheet.Name = "Doublon" 'Renommer l'onglet "Doublon"
        
        Sheets("Pret").Select
        'S�lectionne les cellules A1 � W derni�re ligne'
        Range("A1" & ":W" & derligne_tableau).Select
        Selection.Copy
    
        Sheets("Doublon").Select
        'active et colle les donn�es dans la nouvelle feuille'
        ActiveSheet.Paste
        'Coller les donn�es'
        Application.CutCopyMode = False
        
        Windows("Tampon.xlsm").Activate
        Sheets("Pret").Select
        Range("A1").Select
        
        '____________________________________________________________________________________________________________________'
        'Ouverture d'une message box dans laquelle on demande au technicien le num�ro de pr�t'
        'ligne = Application.InputBox("Quel est le num�ro de pr�t?", Type:=1) 'La variable re�oit la valeur entr�e dans l'InputBox'
        'Active la feuille "Pret"'
        Sheets("Pret").Select
        
        'Masquer les op�rations de la macro
        Application.ScreenUpdating = False
        
    '____________________________________________________________________________________________________________________'
                    'R�cuperer les lignes de num�ro de pr�t'

        Windows("Tampon.xlsm").Activate
        Sheets("Pret").Select
        Range("A1").Select

        Dim y As Long
        y = X + 1
        
        'Montrer le combobox "Num�ro_de_pr�t" (liste d�roulante) avec les options
        Num�ro_de_pr�t.ComboBox1.List = Worksheets("Doublon").Range("A2:A" & y).Value
        Num�ro_de_pr�t.Show
    
CommandButton1_Click:
    'Cacher la fen�tre'
    Num�ro_de_pr�t.Hide
    
    'Active la fen�tre
    Windows("Tampon.xlsm").Activate
    Sheets("Pret").Select
    Range("A1").Select

    '____________________________________________________________________________________________________________________'
                    'tester si la valeur entr�e est num�rique'
    If IsNumeric(ligne) Then

        'Enregistre la valeur rentr�e dans la message box'
        Range("AA1").Value = ligne
        
        If ligne <> "" Then 'Si la valeur est diff�rente de ""

            'Recherche le num�ro de ligne correspondant au retour de pr�t'
            Valeur_reCherchee = Range("AA1").Value
            
            Sheets("Pret").Select
            
            'Dans la plage de donn�es avec tous les doublons, on recherche le num�ro de ligne de pr�t'
            Set PlageDeRecherchededonnees = ActiveSheet.Columns(1)
            'm�thode find, ici on cherche la valeur exacte (LookAt:=xlWhole)'
            Set Trouve = PlageDeRecherchededonnees.Cells.Find(what:=Valeur_reCherchee, LookAt:=xlWhole)
        
            'Traitement de l'erreur possible : Si on ne trouve rien
            If Trouve Is Nothing Then
            
                AdresseTrouvee = Valeur_reCherchee & " n'est pas pr�sent dans " & PlageDeRecherchededonnees.Address
            
            Else 'Traitement pour le cas o� la valeur est trouv�e
                
                AdressereTrouvee = Trouve.Address
                numLigne2 = Trouve.Row

                Windows("Retour_pret.xlsm").Activate
                Sheets("Retour_Pret").Select
                Range("B2").Select 'date
                Range("B2").Copy
                
                Windows("Tampon.xlsm").Activate
                Sheets("Pret").Select
                
                'S�lectionne la ligne du CMS et la colonne M (Date Retour Mat�riel En Pr�t)
                Range("M" & Trouve.Row).Select
                Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
                    :=False, Transpose:=False
                    
                Windows("Retour_pret.xlsm").Activate
                Sheets("Retour_pret").Select
                Range("C8").Select  'Type Retour
                Range("C8").Copy
                
                Windows("Tampon.xlsm").Activate
                Sheets("Pret").Select
                
                'S�lectionne la ligne du CMS et la colonne N (Type Retour)
                Range("N" & Trouve.Row).Select
                Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
                    :=False, Transpose:=False
    
    '____________________________________________________________________________________________________________________'
                    'Supprimer l'onglet "Doublon" sans message'
                
                Windows("Tampon.xlsm").Activate
                Sheets("Pret").Select
                Range("A1").Select
                'Effacer le filtre
                Selection.AutoFilter
                
                Sheets("Doublon").Select
                'Supprime l'onglet "Doublon" sans message'
                On Error Resume Next
                Application.DisplayAlerts = False
                Sheets("Doublon").Delete
                Application.DisplayAlerts = True
                
                Sheets("Pret").Select

                'Affiche les op�rations de la macro'
                Application.ScreenUpdating = True

                MsgBox ("La demande a bien �t� prise en compte")

            End If
        
        End If
        
    End If 'Test si l'entr�e est num�rique
     
    End If 'Test du nombre de doublons

    '____________________________________________________________________________________________________________________'
                'Fin du test de si le technicien veut cr�er un bon de pr�t'
    Else
    
CommandButton2_Click:
    
    Windows("Retour_pret.xlsm").Activate
    Sheets("Retour_pret").Select
    Range("C3: C4, E6, C8").Select
    Selection.ClearContents
    Range("C3").Select
    Exit Sub
    
    End If
    
    'Fermer le fichier en sauvegardant
    Windows("Tampon.xlsm").Activate
    ActiveSheet.Protect "spr"
    
    Workbooks("Tampon.xlsm").Close SaveChanges:=True

    'Effacer les donn�es des cellules
    Range("C3:C4,E6,C8").Select
    Selection.ClearContents
    Range("C3").Select

    Worksheets("Retour_pret").Protect userinterfaceonly:=True, Password:="spr"

    'Masquer les op�rations de la macro
    Application.ScreenUpdating = False

    ActiveSheet.Protect "spr"
    
    Windows("Retour_pret.xlsm").Activate
    Range("C3: C4, E6, C8").Select
    Selection.ClearContents
    Range("C3").Select
    Worksheets("Retour_pret").Protect userinterfaceonly:=True, Password:="spr"

    'Fermer le fichier sans sauvegarder'
    'Workbooks("Retour_pret.xlsm").Close SaveChanges:=False

    If Not (FichOuvert(pret)) Then
        Workbooks.Open Filename:=chemin & "\" & pret
    End If
    Windows("pret.xlsm").Activate
    
End Sub
