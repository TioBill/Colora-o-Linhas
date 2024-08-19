(defun c:Colorir (/ *error* )
    
  (defun *error* (msg)
    (alert msg)
  ) ; defun *error*
  
  (setq time (getvar 'cdate))

  (command "_undo" "begin" "")
  
  (setq multiplicador (getreal "Digite o nivel de salto: "))
  
  (setq terreno (ssget "x" (list
                            (cons '-4 "<and")
                            (cons 0 "polyline")
                            (cons 100 "AcDb3dPolyline")
                            (cons '-4 "and>")
                           )
                )
  ) ; setq terreno
  
  (command "_.zoom" "_object" terreno "")
  

  
  (repeat (setq contador_auxiliar (sslength terreno))
    (setq terreno_atual (ssname terreno (setq contador_auxiliar (1- contador_auxiliar))))
    (setq vlaobj (vlax-ename->vla-object terreno_atual))
    
    (setq coordenadas (vlax-get vlaobj 'Coordinates))    
    
    (setq eixo_z (last coordenadas))
    
    (setq string (rtos eixo_z 2 0))
    
    (setq lista (list (substr string 1 2) (substr string 3 3)))
    (setq sum 0)
    
    (repeat (setq tamanho (length lista))
      (setq sum (+ sum (atoi (nth (setq tamanho (1- tamanho)) lista))))
    )
  
    (setq eixo_z (+ eixo_z (* sum multiplicador)))
    
    (if (<= eixo_z 255)
      (progn
        (setq eixo_z (abs (- eixo_z 255)))
        
        (command "_change" terreno_atual "" "_properties" "_color" "_truecolor" (strcat (rtos eixo_z 2 0) ",255,255") "")
      )
      
      (if (<= eixo_z 510)
        (progn
          (setq eixo_z (abs (- eixo_z 510)))
          
          (command "_change" terreno_atual "" "_properties" "_color" "_truecolor" (strcat "0," (rtos eixo_z 2 0) ",255") "")
        
        )
        
        (progn
          (setq eixo_z (abs (- eixo_z 710)))
          (command "_change" terreno_atual "" "_properties" "_color" "_truecolor" (strcat "255," (rtos eixo_z 2 0) ",0") "")
        
        )
      )
      
    ) ; if
  ) ; repeat
  
  (setq time (- (getvar 'cdate) time))
  (alert (rtos time 2 8))
  
  
  (alert "Fim de execucao.")
  
  (command "_undo" "end" "")

  (princ)

) ; defun Colorir

(alert "LISP Carregada com sucesso! Digite \"colorir\" para comecar.")