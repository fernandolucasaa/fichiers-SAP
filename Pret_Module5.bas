Attribute VB_Name = "Module5"
Function FichOuvert(F As String) As Boolean

On Error Resume Next
FichOuvert = Not Workbooks(F) Is Nothing

End Function

'Supprimer l'enregistrement des modifications lors de la fermeture
Sub Auto_Close()

ThisWorkbook.Saved = True 'Excel r�pond comme si le classeur a d�j� �t� enregistr�

End Sub



