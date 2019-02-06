; image_simd.asm
;
; MI01 - TP Assembleur 2 à 5
;
; Réalise le traitement d'une image bitmap 32 bits par pixel.

title image_simd.asm

.code

; **********************************************************************
; Sous-programme _process_image_asm 
; 
; Réalise le traitement d'une image 32 bits.
; 
; Le passage des paramètres respecte les conventions fastcall x64 sous 
; Windows. La fonction prend les paramètres suivants, dans l'ordre :
;  - biWidth : largeur d'une ligne en pixels (32 bits non signé)
;  - biHeight de l'image en lignes (32 bits non signé)
;  - img_src : adresse du premier pixel de l'image source
;  - img_temp1 : adresse du premier pixel de l'image temporaire 1
;  - img_temp2 : adresse du premier pixel de l'image temporaire 2
;  - img_dest : adresse du premier pixel de l'image finale
;
; La fonction ne retourne pas de valeur.
;
; Les registes rbx, rbp, rdi, rsi, rsp, r12, r13, r14, et r15 doivent
; être sauvegardés si vous les utilisez (sauvegarde par l'appelé). Les
; autres registres peuvent être modifiés sans risque (sauvegardés par 
; l'appelant).
; **********************************************************************

public  process_image_simd
process_image_simd  proc        ; Point d'entrée du sous programme

        ; *****************************
        ; Ajoutez votre code ci-dessous
        ; *****************************

        ret                     ; Retour à la fonction d'appel
process_image_simd  endp

end