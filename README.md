# Web SmallMol S.A
Web disenyada per l'empresa SmallMol S.A. per visualitzar dades d'una base de dades amb grafics personalitzats. [Informe Client](/Informe_Client.pdf).
## Estructura i com utilitzar-ho
Tot el codi de la web esta al fitxer [app.R](/app.R), per tant amb obrir aquell fitxer amb RStudio i executant-lo hi haurà suficient.
La base de dades a utilitzar es el fitxer [DB_SmallMol.csv](/DB_SmallMol.csv), que es una versió "netejada" de la [base de dades original](/bbdd.csv).
## Explicació del codi
### Dependencies
Hem utilitzat la biblioteca ggplot2 que permet crear gràfics personalitzats i de qualitat, i shiny per fer la interficie i el servidor.
### Funcionament
La ui és la interfície d'usuari en la que es troba fluidPage que és la secció en la qual es defineix el disseny visual de la pàgina.
El tabsetPanel() permet crear un conjunt de pestanyes o tabs dins de la interfície d'usuari. La funció tabsetPanel() defineix el contenidor principal per a les pestanyes,
mentre que tabPanel() s'usa per crear cada pestanya individual.
Llavors dins del primer tabPanel, que és la taula trobem la funció sidebarPanel que crea un panell lateral, en el qual quan posem un arxiu amb el fileInput podem escollir els diferents checkboxs perquè es mostrin en la taula.
Aquests checkboxs tenen la id i el label que és el que veu l'usuari. El primer podem veure que té un value = TRUE que serveix perquè estigui predeterminat en el panell.
El mainPanel() defineix la regió principal de la interfície d'usuari i mostra una taula interactiva amb l'identificador "table1" utilitzant DT::dataTableOutput().
En el segon tab, és a dir en la segona pestanya trobarem els grafics Kamens i RO5, en dues pestanyes interiors.
El Kmeans pots escollir en la variable x i la variable y les seguents opcions: "Molecular.Weight", "Polar.Surface.Area", "AlogP", "X.Rotatable.Bonds", "CX.Acidic.pKa", "CX.Basic.pKa", "CX.LogP", "Aromatic.Rings", "Heavy.Atoms", "HBA..Lipinski.", "HBD..Lipinski."
Llavors amb aquestes dues opcions et fa un gràfic del qual pots escollir la quantitat de clusters el que apareix aquest.
Després en la pestanya de rule of 5 doncs trobem un grafic de barres en el que indica quantes Small Molecules compleixen quina quantitat de les cinc normes.
Tal com ho indica la regla de Lipinski, en general, un principi actiu i perquè sigui possible la seva administració per via oral no ha de violar més d'una de les consideracions següents:
No ha de contenir més de cinc donadors d' enllaços per ponts d'hidrogen ( àtoms de nitrogen o oxigen amb almenys un àtom d' hidrogen ).
No ha de contenir més de deu acceptors denllaços per ponts dhidrogen (àtoms de nitrogen, oxigen o fluor ).
Ha de posseir un pes molecular inferior a 500 uma .
Ha de posseir un coeficient de repartiment octanol-aigua (log P ) inferior a 5. 3 
La primera barra seria la quantitat de molecules que no incompleixen cap, la que posa 1 es que incompleix una i així consecutivament fins a 4.

El server conté el codi que gestiona el comportament i les respostes interactives de l'aplicació basades en les accions de l'usuari.
La funció del servidor rep les dades d'entrada (input) i genera les sortides (output).
"d1 <- reactive({ ... })" defineix una funció anomenada d1 que s'actualitza automàticament quan hi ha canvis en les entrades input. Aquesta funció llegirà un arxiu CSV seleccionat per l'usuari i realitzarà algunes transformacions en les dades llegides.
La línia de codi "req(input$file1)" comprova si s'ha seleccionat un fitxer, si no és així s'aturarà l'execució.
"inFile <- input$file1" obté l'objecte de l'arxiu seleccionat per l'usuari.
Les dades de l'arxiu que hem pujat si accedeix amb inFile$datapath i separa les columnes del CSV amb ";".
Aquesta línia "include <- c("ChEMBL.ID")" i les següents línies fins al return, s'encarreguen de seleccionar les columnes del CSV que ha escollit l'usuari, mitjançant les checkbox.
De la línia 76 a la 78 - Agafes des de server la línia 26, que és la taula llavors "renderDataTable" és el tipus de taula i a dins li pases els paràmetres, que és d1, l'array amb la informació ja seleccionada,
"lengthMenu", que permet a l'usuari seleccionar el nombre de files a mostrar per pàgina, i "pageLength", que defineix el nombre de files per defecte per pàgina.
En la part de K-means, la funció selectedData() és una funció reactiva que obté les dades seleccionades del data frame retornat per d2(). Filtra les files que contenen valors no nuls per a les columnes seleccionades xcol i ycol.
El nombre de clusters és especificat per l'usuari a través de input$clusters.
La sortida output$plot1 és un gràfic que utilitza les dades seleccionades i els clusters generats per visualitzar-los. 
S'estableix una paleta de colors, es defineixen els paràmetres del gràfic i es dibuixen els punts corresponents a les dades seleccionades, 
cada punt amb el color del cluster al qual pertany. També s'afegeixen els centres dels clusters al gràfic com a punts de diferent forma i mida.
El grafic de "rule of 5" es fa agafant la columna de la base de dades pujada i iterant-la amb un for augmentant en 1 la casella corresponent de la variable "graphrof" de la línea 131, que després s'utilitzarà per fer el grafic de barres "barplot" amb 6 columnes (els que incompleixen 0, 1, 2, 3, 4 i 5 normes).
