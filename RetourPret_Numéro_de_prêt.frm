VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} Num�ro_de_pr�t 
   Caption         =   "Num�ro de pr�t"
   ClientHeight    =   3180
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   4710
   OleObjectBlob   =   "RetourPret_Num�ro_de_pr�t.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "Num�ro_de_pr�t"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub UserForm_QueryClose(cancel As Integer, CloseMode As Integer)
If CloseMode = 0 Then cancel = True
End Sub

Private Sub CommandButton1_Click()

ligne = Num�ro_de_pr�t.ComboBox1.Value
    
    'Active la fen�tre Pret'
    Windows("Tampon.xlsm").Activate
    'active la feuille "pret"'
    Sheets("Pret").Select
    
    '____________________________________________________________________________________________________________________'
                    'tester si la valeur entr�e est num�rique'
    If IsNumeric(ligne) Then

    'Enregistre la valeur rentr�e dans la message box'
    Range("AA1").Value = ligne
     If ligne <> "" Then 'Si la valeur est diff�rente de "" '

    'Recherche le num�ro de ligne correspondant au retour de pr�t'
    Valeur_reCherchee = Range("AA1").Value
    'Active la feuille "Pr�t"'
    Sheets("Pret").Select
    'Dans la plage de donn�es avec tous les doublons, on recherche le num�ro de ligne de pr�t'
    Set PlageDeRecherchededonnees = ActiveSheet.Columns(1)
    'm�thode find, ici on cherche la valeur exacte (LookAt:=xlWhole)'
    Set Trouve = PlageDeRecherchededonnees.Cells.Find(what:=Valeur_reCherchee, LookAt:=xlWhole)
    
    'traitement de l'erreur possible : Si on ne trouve rien :
    If Trouve Is Nothing Then
    
        'ici, traitement pour le cas o� la valeur n'est pas trouv�e
        AdresseTrouvee = Valeur_reCherchee & " n'est pas pr�sent dans " & PlageDeRecherchededonnees.Address
    
    Else
        'ici, traitement pour le cas o� la valeur est trouv�e
        AdressereTrouvee = Trouve.Address
        numLigne2 = Trouve.Row

    'Active la fen�tre Retour_pret'
    Windows("Retour_pret.xlsm").Activate
    'active la feuille "Bon_pret"'
    Sheets("Retour_Pret").Select
    'S�lectionne la cellule B2 = date'
    Range("B2").Select
    'Copie la cellule A1'
    Range("B2").Copy
    'Active la fen�tre Pret'
    Windows("Tampon.xlsm").Activate
    'active la feuille "pret"'
    Sheets("Pret").Select
    'S�lectionne la ligne du CMS et la colonne L'
    Range("M" & Trouve.Row).Select
    'S�lectionne la cellule et la colle'
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
        
    'Active la fen�tre Retour_pret'
    Windows("Retour_pret.xlsm").Activate
    'active la feuille "Retour_pret"'
    Sheets("Retour_pret").Select
    'S�lectionne la cellule C8'
    Range("C8").Select
    'Copie la cellule C8 = type de retour'
    Range("C8").Copy
    'Active la fen�tre Pret'
    Windows("Tampon.xlsm").Activate
    'active la feuille "pret"'
    Sheets("Pret").Select
    'S�lectionne la ligne du CMS et la colonne M'
    Range("N" & Trouve.Row).Select
    'S�lectionne la cellule et la colle'
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    
    'Active la fen�tre Pret'
    Windows("Tampon.xlsm").Activate
    'active la feuille "pret"'
    Sheets("Pret").Select
    'Effacer le filtre'
    Selection.AutoFilter
    
    '____________________________________________________________________________________________________________________'
                    'Supprimer l'onglet "Doublon" sans message'
    'Active la fen�tre Pret'
    Windows("Tampon.xlsm").Activate
    'active la feuille "pret"'
    Sheets("Pret").Select
    'S�lectionne la cellule A1'
    Range("A1").Select
    'Effacer le filtre'
    Selection.AutoFilter
    'S�lectionne l'onglet "Doublon"'
    Sheets("Doublon").Select
    'Supprime l'onglet "Doublon" sans message'
    On Error Resume Next
    Application.DisplayAlerts = False
    Sheets("Doublon").Delete
    Application.DisplayAlerts = True
    'Active la feuille "pret"'
    Sheets("Pret").Select

    Unload Num�ro_de_pr�t
        End If
      End If
     End If

End Sub

Private Sub CommandButton2_Click()

    '____________________________________________________________________________________________________________________'
                    'Supprimer l'onglet "Doublon" sans message'
    'Active la fen�tre Pret'
    Windows("Pret.xlsm").Activate
    'active la feuille "pret"'
    Sheets("Pret").Select
    'S�lectionne la cellule A1'
    Range("A1").Select
    'Effacer le filtre'
    Selection.AutoFilter
    'S�lectionne l'onglet "Doublon"'
    Sheets("Doublon").Select
    'Supprime l'onglet "Doublon" sans message'
    On Error Resume Next
    Application.DisplayAlerts = False
    Sheets("Doublon").Delete
    Application.DisplayAlerts = True
    'Active la feuille "pret"'
    Sheets("Pret").Select

    'Active la fen�tre Pret'
    Windows("Retour_Pret.xlsm").Activate
    'active la feuille "pret"'
    Sheets("Retour_Pret").Select

    Unload Num�ro_de_pr�t
    Exit Sub
End Sub
