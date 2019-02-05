; image_simd.asm
;
; MI01 - TP Assembleur 2 � 5
;
; R�alise le traitement d'une image bitmap 32 bits par pixel.

title image_simd.asm

.code

; **********************************************************************
; Sous-programme _process_image_asm
;
; R�alise le traitement d'une image 32 bits.
;
; Le passage des param�tres respecte les conventions fastcall x64 sous
; Windows. La fonction prend les param�tres suivants, dans l'ordre :
;  - biWidth : largeur d'une ligne en pixels (32 bits non sign�)
;  - biHeight de l'image en lignes (32 bits non sign�)
;  - img_src : adresse du premier pixel de l'image source
;  - img_temp1 : adresse du premier pixel de l'image temporaire 1
;  - img_temp2 : adresse du premier pixel de l'image temporaire 2
;  - img_dest : adresse du premier pixel de l'image finale
;
; La fonction ne retourne pas de valeur.
;
; Les registes rbx, rbp, rdi, rsi, rsp, r12, r13, r14, et r15 doivent
; �tre sauvegard�s si vous les utilisez (sauvegarde par l'appel�). Les
; autres registres peuvent �tre modifi�s sans risque (sauvegard�s par
; l'appelant).
; **********************************************************************

public  process_image_simd
process_image_simd  proc        ; Point d'entr�e du sous programme

				mov		r11, rcx   ; r11 registre tampon
				imul	rcx, rdx ; calcul du nombre total de pixel dans rcx

	    	mov		rax, 00264b0e00264b0eh ; stockage de 2 série de coefficients adaptés dans xmm1
				movd xmm1, rax
				punpcklqdq xmm1, xmm1 ; copie de la partie basse dans la partie haute de xmm1
				mov 	rax, 0001000100010001h
				movd xmm3, rax
				pxor xmm4, xmm4

boucle:	movd	xmm0, qword ptr[r8 + 4*rcx - 12] ; stockage de 2 pixels pixel dans xmm0
				pslldq	xmm0, 8 ; décalage des pixels dans la partie haute de xmm0
				movd	xmm2, qword ptr[r8 + 4*rcx - 4] ; stockage de 2 pixel dans xmm2
				por xmm0, xmm2 ; stockage des 2 pixels de xmm2 dans la partie basse de xmm0

    		pmaddubsw	xmm0, xmm1 ; calcul des intensités
    		phaddw	xmm0, xmm4
				paddw xmm0, xmm0
				psrldq xmm0, 1 ; élimination de la partie décimale
				pmaddubsw xmm0, xmm3 ; reconstruction du registre
				punpcklbw xmm0, xmm4

				movd qword ptr[r9 + 4*rcx - 4], xmm0 ; stockage des niveaux de bleu dans 4 pixels de temp1
				psrldq xmm0, 8
				movd qword ptr[r9 + 4*rcx - 12], xmm0

				sub		rcx, 4 ; decrementation du compteur avec pas de 4
				cmp		rcx, 0
				jg		boucle ; si supérieur à 0 alors boucle

				jmp 	fin   ; saut inconditionnel à la fin du programme

        mov		r10, r11 ; taille ligne
        mov		r8, r9 ; temp1
        mov		r9, [rsp+40] ; temp2
        sub		rdx, 2 ; compteur ligne

        mov		rax, r10 ; initialisation de r9 à b22
        imul	rax, 4
        add		r9, rax
        add		r9, 4

ligne:	mov		rcx, r10 ;compteur colonne
        sub		rcx, 2

colonne:	xor 	rax, rax ; calcul de Gx
          add		eax, dword ptr[r8 + 8]
          add		eax, dword ptr[r8 + 4*r10 + 8]
          add		eax, dword ptr[r8 + 4*r10 + 8]
          add		eax, dword ptr[r8 + 8*r10 + 8]
          sub		eax, dword ptr[r8]
          sub		eax, dword ptr[r8 + 4*r10]
          sub		eax, dword ptr[r8 + 4*r10]
          sub		eax, dword ptr[r8 + 8*r10]

          cmp		eax, 0 ; valeur absolue de Gx
          jge		abs_Gx
          neg		eax

abs_Gx:		mov		r11, rax ;stockage de abs(Gx)

          xor 	rax, rax ; calcul de Gy
          add		eax, dword ptr[r8]
          add		eax, dword ptr[r8 + 4]
          add		eax, dword ptr[r8 + 4]
          add		eax, dword ptr[r8 + 8]
          sub		eax, dword ptr[r8 + 8*r10]
          sub		eax, dword ptr[r8 + 8*r10 + 4]
          sub		eax, dword ptr[r8 + 8*r10 + 4]
          sub		eax, dword ptr[r8 + 8*r10 + 8]

          cmp		eax, 0 ; valeur absolue de Gy
          jge		abs_Gy
          neg		eax

abs_Gy:		add		r11, rax ; calcul de G

          mov		rax, 255 ; saturation
          sub		rax, r11
          mov		r11, rax
          cmp		r11d, 0
          jge		abs_G
          xor		r11, r11

abs_G:		mov		rax, r11 ; niveau de gris
          shl		r11, 8
          add		r11, rax
          shl		r11, 8
          add		r11, rax

          mov		[r9], r11d ; affectation de la valeur du pixel destination

          add		r9, 4 ; pixel suivant
          add		r8, 4
          dec		rcx ; décrementation du compteur
          cmp		rcx, 0
          jg		colonne ; boucle sur colonne

        add		r9, 8 ; ligne suivante
        add		r8, 8
        dec		rdx ; décrementation du compteur
        cmp		rdx, 0
        jg		ligne ; boucle sur ligne

fin:    ret                     ; Retour de la fonction d'appel                   ; Retour � la fonction d'appel
process_image_simd  endp

end
