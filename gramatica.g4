grammar gramatica;

IDENT: ('$'|LETRAS)('$'|LETRAS|NUMEROS|'_')* ;
CONSTINT:BDECIMAL|BOCTAL|BHEXA ;
CONSTFLOAT: BDECIMALF|BOCTALF|BHEXAF;
CONSTLIT:'\''(SIMBOLOS|ESPACIO_BLANCO|'\\''\''(SIMBOLOS|ESPACIO_BLANCO)+'\\''\'')+'\'';
COMENTARIOS1:'//' ~[\r\n]* SALTOLINEA ->skip ;
COMENTARIOS2:'/*'~[*/]*'*/' ->skip ;

ESPACIO_BLANCO: [ \t\r\n]+ -> skip;
SALTOLINEA: [\r\n];
SIMBOLOS:(LETRAS|NUMEROS);
LETRAS: [a-zA-Z];
NUMEROS: [0-9];
BDECIMAL: [+-]?[0-9]+;
BOCTAL: '0'[+-]?[0-7]+;
BHEXA: '0x'[+-]?[0-9A-F]+;
BDECIMALF: [+-]?[0-9]+('.'[0-9]+);
BOCTALF: '0'[+-]?[0-7]+('.'[0-7]+);
BHEXAF: '0x'[+-]?[0-9A-F]+('.'[0-9A-F]+);

program: defines[""] partes {if($partes.main.equals("")){
                                System.out.println("unit libreria;\n" +$defines.v + $partes.v.trim().substring(0,$partes.v.trim().length()-1) + ".");
                             } else {
                                if($partes.var.trim().equals("")){
                                  System.out.println("program Main;\n" +$defines.v + $partes.v + $partes.main);
                                } else {
                                  System.out.println("program Main;\n" +$defines.v +"var"+"\n"+ $partes.var+ "\n" +$partes.v + $partes.main);
                                }
                             }
                             }
         ;
defines[String i] returns[String v]: {$v= "";}
                                              | '#define' IDENT ctes defines[$IDENT.text] {if($i.equals("")){
                                                                                                $v= "const" + "\r\n\t" + $IDENT.text  + " = " + $ctes.v +";"  + "\n" + $defines.v;
                                                                                            } else {
                                                                                                $v= "\t" + $IDENT.text  + " = " + $ctes.v +";" + "\n" + $defines.v;
                                                                                            }
                                                                                           }
                                              ;
ctes returns[String v]: CONSTINT {$v= $CONSTINT.text;}
                |CONSTFLOAT {$v= $CONSTFLOAT.text;}
                |CONSTLIT {$v= $CONSTLIT.text;}
                ;
partes returns [String v, String var, String main]: part partes2[$part.v] {$v= $partes2.v;
                                                               $var = $part.var + $partes2.var;
                                                               $main = $part.main + $partes2.main;
                                                              }
                         ;
partes2[String i] returns [String v, String var, String main]: {$v= $i;
                                                    $var = "";
                                                    $main = "";}
                          | part partes2[$i] {$v= $part.v + $partes2.v;
                                                        $var = $part.var + $partes2.var;
                                                        $main = $part.main + $partes2.main;
                                                        }
                          ;
part returns [String v, String var, String main]: type restpart[$type.v] {$var = $restpart.var;
                                                             if($restpart.main.equals("")){
                                                                if($type.v.equals("void")){
                                                                   $v = "procedure " + $restpart.v;
                                                                } else {
                                                                   $v = "function " +$restpart.v;
                                                                }
                                                                $main ="";
                                                             } else {
                                                                $v = $restpart.v;
                                                                $main = $restpart.main;
                                                             }

                                                            }
                        ;
restpart[String t] returns [String v, String var, String main]: IDENT '(' listparam ')' blq[$IDENT.text,"","",""] {$v =$IDENT.text + "(";
                                                                                             if(!$listparam.enteros.equals("")){
                                                                                                $v = $v + $listparam.enteros + " : INTEGER";
                                                                                                if(!$listparam.reales.equals("")){
                                                                                                    $v = $v +"; " + $listparam.reales + " : REAL";
                                                                                                }
                                                                                             } else if(!$listparam.reales.equals("")){
                                                                                                 $v = $v + $listparam.reales + " : REAL";
                                                                                             }
                                                                                             if(!$t.equals("void")){
                                                                                                $v=  $v+ ")"+ ": "+ $t+ ";\n" +$blq.v+ ";\n\n";
                                                                                             } else {
                                                                                                $v=  $v+")"+ ";\n" +$blq.v +";\n\n";
                                                                                             }
                                                                                             if($IDENT.text.equals("main")){
                                                                                                $v = "" ;
                                                                                                $main = $blq.v + ".";
                                                                                                $var= $blq.var;
                                                                                             } else {
                                                                                                $main = "";
                                                                                                $var = "";
                                                                                             }
                                                                                            }
                           | IDENT '(''void'')' blq[$IDENT.text,"","",""] {if(!$t.equals("void")){
                                                                  $v= $IDENT.text + "()"+ ": "+ $t+ ";\n" +$blq.v + ";\n\n";
                                                              } else {
                                                                  $v= $IDENT.text + "()"+ ";\n" +$blq.v + ";\n\n";
                                                              }
                                                              if($IDENT.text.equals("main")){
                                                                 $v = "";
                                                                 $var= $blq.var;
                                                                 $main = $blq.v + ".";
                                                              } else {
                                                                 $var = "";
                                                                 $main = "";
                                                              }
                                                             }
                           | IDENT '('')' blq[$IDENT.text,"","",""] {if(!$t.equals("void")){
                                                                         $v= $IDENT.text + "()"+ ": "+ $t+ ";\n" +$blq.v + ";\n\n";
                                                                     } else {
                                                                          $v= $IDENT.text + "()"+ ";\n" +$blq.v + ";\n\n";
                                                                     }
                                                                     if($IDENT.text.equals("main")){
                                                                          $v = "";
                                                                          $var= $blq.var;
                                                                          $main = $blq.v + ".";
                                                                     } else {
                                                                          $var = "";
                                                                          $main = "";
                                                                     }
                                                                        this.notifyErrorListeners("Error en la entrada de los parametros");
                                                                     }
                            ;
blq[String return, String tabs, String condfor, String valorfor] returns [String v, String var]: '{' sentlist[$return, $tabs] '}' {
                                                                                  if(!$return.equals("main")){
                                                                                    if(!$sentlist.enteros.equals("")){
                                                                                        $v = $tabs + "var\n" +$tabs +"\t" +$sentlist.enteros + " : INTEGER ;"+ "\n";
                                                                                        if(!$sentlist.reales.equals("")){
                                                                                            $v = $v  +$tabs +"\t"+ $sentlist.reales + " : REAL ;"+ "\n";
                                                                                        }
                                                                                    }else if(!$sentlist.reales.equals("")){
                                                                                        $v = $tabs + "var\n" +$tabs + $sentlist.reales + " : REAL ;"+ "\n";
                                                                                    } else {
                                                                                        $v = "";
                                                                                    }
                                                                                  } else{
                                                                                    if(!$sentlist.enteros.equals("")){
                                                                                        $var = $tabs  +$tabs +"\t" +$sentlist.enteros + " : INTEGER ;"+ "\n";
                                                                                        if(!$sentlist.reales.equals("")){
                                                                                            $var = $var  +$tabs +"\t"+ $sentlist.reales + " : REAL ;"+ "\n";
                                                                                        }
                                                                                    }else if(!$sentlist.reales.equals("")){
                                                                                        $var = $tabs + $sentlist.reales + " : REAL ;"+ "\n";
                                                                                    } else {
                                                                                        $var = "";
                                                                                    }
                                                                                    $v="";
                                                                                  }
                                                                                  $v= $v + $tabs +"begin" + "\n" + $sentlist.v + "\n"  ;

                                                                                  if(!$condfor.equals("")){
                                                                                    if(!$valorfor.equals("1"))
                                                                                        $v = $v + $tabs +"\t" + $condfor +";"+ "\n";
                                                                                  }
                                                                                  $v = $v  + $tabs +"end";
                                                                              }
                      ;
listparam returns [String enteros, String reales]: type IDENT listparam2{if($type.v.equals("INTEGER")){
                                                                     if(!$listparam2.enteros.equals("")){
                                                                         $enteros =  $IDENT.text+", " + $listparam2.enteros;
                                                                     } else {
                                                                         $enteros =  $IDENT.text;
                                                                     }
                                                                     $reales = $listparam2.reales;
                                                                  } else if($type.v.equals("REAL")){
                                                                     if(!$listparam2.reales.equals("")){
                                                                        $reales =  $IDENT.text+", " + $listparam2.reales;
                                                                     } else {
                                                                        $reales =  $IDENT.text;
                                                                     }
                                                                        $enteros =$listparam2.enteros;
                                                                     } else {
                                                                         $enteros =$listparam2.enteros;
                                                                         $reales = $listparam2.reales;
                                                                     }

                                                                  }
                                                                  ;
listparam2 returns [String enteros,String reales]:{$enteros="";$reales="";}
                            |',' type IDENT listparam2{if($type.v.equals("INTEGER")){
                                                          if(!$listparam2.enteros.equals("")){
                                                              $enteros =  $IDENT.text+", " + $listparam2.enteros;
                                                          } else {
                                                               $enteros =  $IDENT.text;
                                                          }
                                                                $reales = $listparam2.reales;
                                                          } else if($type.v.equals("REAL")){
                                                              if(!$listparam2.reales.equals("")){
                                                                   $reales =  $IDENT.text+", " + $listparam2.reales;
                                                              } else {
                                                                   $reales =  $IDENT.text;
                                                              }
                                                                   $enteros =$listparam2.enteros;
                                                              } else {
                                                                   $enteros =$listparam2.enteros;
                                                                   $reales = $listparam2.reales;
                                                              }
                                                          }
                                                          ;

type returns [String v]: 'void' {$v= "void";}
                        | 'int' {$v= "INTEGER";}
                        | 'float' {$v= "REAL";}
                        ;

sentlist[String return, String tabs] returns [String v, String enteros, String reales]: sent[$return,$tabs] sentlist2[$return,$tabs] {if($sent.v.equals("")){
                                                                                                     $v= $sentlist2.v ;
                                                                                              } else {
                                                                                                   if($sentlist2.v.equals("")){
                                                                                                     $v= $tabs +"\t"+$sent.v;
                                                                                                   } else {
                                                                                                        $v= $tabs+"\t"+$sent.v + "\n"+ $sentlist2.v ;
                                                                                                   }
                                                                                              }
                                                                                              if($sent.var.contains("INTEGER")){
                                                                                                if(!$sentlist2.enteros.equals("")){
                                                                                                    $enteros =  $sent.var.split(":")[0]+", " + $sentlist2.enteros;
                                                                                                } else {
                                                                                                    $enteros =  $sent.var.split(":")[0];
                                                                                                }
                                                                                                  $reales = $sentlist2.reales;
                                                                                              } else if($sent.var.contains("REAL")){
                                                                                                if(!$sentlist2.reales.equals("")){
                                                                                                    $reales =  $sent.var.split(":")[0]+", " + $sentlist2.reales;
                                                                                                } else {
                                                                                                    $reales =  $sent.var.split(":")[0];
                                                                                                }
                                                                                                  $enteros =$sentlist2.enteros;
                                                                                              } else {
                                                                                                  $enteros =$sentlist2.enteros;
                                                                                                  $reales = $sentlist2.reales;
                                                                                              }
                                                                                          }
                            ;
sentlist2[String return, String tabs] returns [String v, String enteros, String reales]: {$v = "";
                                                            $enteros =""; $reales ="";}
                                      | sent[$return,$tabs] sentlist2[$return,$tabs] {if($sent.v.equals("")){
                                                                                $v= $sentlist2.v ;
                                                                            } else {
                                                                                if($sentlist2.v.equals("")){
                                                                                      $v= $tabs+"\t"+$sent.v;
                                                                                } else {
                                                                                      $v= $tabs+"\t"+$sent.v + "\n"+ $sentlist2.v ;
                                                                                }
                                                                            }
                                                                            if($sent.var.contains("INTEGER")){
                                                                                if(!$sentlist2.enteros.equals("")){
                                                                                    $enteros =  $sent.var.split(":")[0]+", " + $sentlist2.enteros;
                                                                                } else {
                                                                                    $enteros =  $sent.var.split(":")[0];
                                                                                }
                                                                                $reales = $sentlist2.reales;
                                                                            } else if($sent.var.contains("REAL")){
                                                                                if(!$sentlist2.reales.equals("")){
                                                                                    $reales =  $sent.var.split(":")[0]+", " + $sentlist2.reales;
                                                                                } else {
                                                                                    $reales =  $sent.var.split(":")[0];
                                                                                }
                                                                                $enteros =$sentlist2.enteros;
                                                                            }else {
                                                                                $enteros =$sentlist2.enteros;
                                                                                $reales = $sentlist2.reales;
                                                                            }
                                                                          }
                                      ;
sent[String return, String tabs] returns [String v, String var]: type lid ';' {$v="";
                                                                  $var = $lid.v +": "+ $type.v + ";" ;
                                                                  }
                        | IDENT '=' exp ';' {$v = $IDENT.text + " := " + $exp.v + ";" ;
                                                $var ="";}
                        | IDENT '(' lexp ')' ';' {$v = $IDENT.text + "(" + $lexp.v + ")" + ";" ;
                                                    $var ="";}
                        | IDENT '('')'';' {$v = $IDENT.text + "(" + ")" + ";" ;
                                            $var ="";}
                        | 'return' exp ';' {$v = $return + " := " + $exp.v + ";" ;
                                            $var ="";}
                        | 'if' '(' lcond ')' b1=blq["",$tabs + "\t","",""] 'else' b2=blq["",$tabs + "\t","",""] {$v = "if " + $lcond.v + " then\n"  + $b1.v + "\n"+ $tabs +"\t"+"else\n" + $b2.v +";";
                                                                                                       $var ="";}
                        | 'while' '(' lcond ')' blq["",$tabs + "\t","",""]{$v = "while " + $lcond.v + " do\n"  + $blq.v+";";
                                                                     $var ="";}
                        | 'do' blq["",$tabs + "\t","",""] 'until' '(' lcond ')'{$v = "repeat\n" + $blq.v +"\n"+ $tabs + "\t"+"until " + $lcond.v +";";
                                                                            $var="";}
                        | 'for' '(' IDENT '=' e1=exp ';' lcond ';' IDENT '=' e2=exp ')' blq["",$tabs + "\t", $IDENT.text + ":=" + $e2.v, $e2.forowhile]{if($e2.forowhile.equals("1")){
                                                                                                                                                            if($exp.v.contains("+")){
                                                                                                                                                                $v = "for " + $IDENT.text + ":=" + $e1.v + " to " + $lcond.valorfor +" do\n" + $blq.v+";";
                                                                                                                                                            } else {
                                                                                                                                                                $v = "for " + $IDENT.text + ":=" + $e1.v + " downto " + $lcond.valorfor +" do\n" + $blq.v+";";
                                                                                                                                                            }
                                                                                                                                                         } else {
                                                                                                                                                            $v = "while " + $lcond.v + " do\n"  + $blq.v+";";
                                                                                                                                                         }
                                                                                                                                                        $var ="";}
                        ;
lid returns [String v]: IDENT lid2 {$v= $IDENT.text + $lid2.v;}
                      ;
lid2 returns [String v]: {$v= "";}
                      | ',' IDENT lid2 {$v=", " +$IDENT.text + $lid2.v;}
                      ;
lexp returns [String v]: exp lexp2[$exp.v] {$v= $lexp2.v;}
                        ;
lexp2[String i] returns [String v]: {$v= $i;}
                                  | ',' exp lexp2[$i + $exp.v] {$v= "," + $exp.v + $lexp2.v;}
                                  ;
exp returns [String v, String forowhile]: factor exp2[$factor.v] {$v= $exp2.v; $forowhile=$exp2.forowhile;}
                        ;
exp2[String i] returns [String v, String forowhile]: {$v= $i; $forowhile="";}
                                | op exp {$v= $i + $op.v + $exp.v; $forowhile=$exp.v;}
                                ;
op returns [String v]: '+' {$v= " + ";}
                    | '-' {$v= " - ";}
                    | '*' {$v= " * ";}
                    | '/' {$v= " div ";}
                    | '%' {$v= " mod ";}
                    ;
factor returns [String v]: IDENT '(' lexp ')' {$v= $IDENT.text + "(" + $lexp.v + ")";}
    | IDENT '('')' {$v= $IDENT.text + "(" + ")";}
    | '(' exp ')' {$v= "(" + $exp.v + ")";}
    | IDENT {$v= $IDENT.text;}
    | ctes {$v= $ctes.v;}
    ;
lcond returns [String v,String valorfor]: cond lcond2 {$v= $cond.v + $lcond2.v;
                                                        $valorfor=$cond.valorfor;}
                        | '!' cond{$v= "!" + $cond.v;}
                        ;
lcond2 returns [String v]: {$v="";}
                                | opl lcond{$v = $opl.v + $lcond.v;}
        ;
opl returns [String v]: '||' {$v= "||";}
                      | '&&'{$v= "&&";}
                      ;
cond returns [String v,String valorfor]: e1=exp opr e2=exp{$v= $e1.v + $opr.v + $e2.v;
                                                       $valorfor = $e2.v;}
                                                       ;
opr returns [String v]: '==' {$v= "==";}
                        | '<' {$v= "<";}
                        | '>' {$v= ">";}
                        | '>=' {$v= ">=";}
                        | '<='{$v= "<=";};

