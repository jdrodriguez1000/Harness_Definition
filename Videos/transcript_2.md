Video: 
Stack para proyectos pequeños que funciona en días
Enlace: https://youtu.be/dGhJCFSpa-o

0:00 En lo personal, cuando hablo de desarrollar aplicaciones para clientes,
0:02 una forma bastante rápida de poder terminar el trabajo es utilizar
0:05 herramientas que ya están muy bien definidas y que nos permiten poder hacer
0:09 cosas comunes como son autenticación, subida de archivos, renderizado de
0:13 múltiples páginas y obviamente conectados todos a una base de datos. Y
0:16 son proyectos que se utilizan bastante, es decir, son bastante comunes de ver y
0:19 al desarrollarlos ya tengo una set de herramientas bastante rápidas para poder
0:23 generarlas. lo que antes generaba en meses, estos días los puedo generar en
0:26 cuestión de días y esto es gracias, obviamente, a la IA más algunas
0:29 herramientas que utilizo en mi día a día. Así que para poder simplificarles
0:32 todo esto, el día de hoy les voy a comentar todo lo que estoy utilizando
0:35 para este tipo de proyectos pequeños y que son baratos. Por ejemplo, un
0:38 proyecto pequeño puede ser que sea una aplicación web con algún par de usuarios
0:42 que lo usan todos los días, desplegada en un dominio y con una conexión a base
0:46 de datos frontend y backend. Entonces, para aquellos que quieran saber cómo se
0:49 puede llegar a crear todo esto, en este video les voy a comentar un paso a paso
0:52 de todo lo que uso y obviamente de esta forma pueden ir resolviendo algunas
0:55 dudas de qué usar ustedes también. Así que si les interesa pues vamos a
0:58 empezar.
0:59 Antes de empezar, si están buscando en dónde subir sus aplicaciones web creadas
1:02 con lenguajes como Python, Node 10, PHP, Ruby y otros lenguajes o framework
1:07 basados en estos lenguajes, pueden utilizar Hostinger, el cual te permite
1:10 desplegar aplicaciones fácilmente utilizando sus servicios de BPS, los que
1:13 te van a permitir enfocarte en crear aplicaciones web mientras Hostinger se
1:16 encarga de servir tu proyecto. Además, también te permite configurar plantillas
1:19 BPS para que puedas tener el proceso de instalación mucho más fácil. El primer
1:22 paso es adquirir un plan de alojamiento BPS en Hostinger. Una vez que hayas
1:25 adquirido tu plan, puedes acceder a tu BPS a través del panel de control de
1:28 Hostinger y allí podrás seleccionar el sistema operativo de tu preferencia.
1:31 También puedes crear un nuevo usuario y modificar privilegios para este. Y
1:34 puedes utilizar este VPS para instalar tu CMS preferido, como puede ser
1:37 WordPress o subir cualquier tipo de proyecto que tengas desarrollado en
1:40 cualquier lenguaje. Además que podrás configurar también un firewall para
1:43 poder proteger mucho más tu sitio web. Para conocer más de los VPS de
1:46 Hostinger, te dejo el enlace en la descripción. Muy bien, antes de que
1:49 empecemos a hablar acerca del stack que utiliza actualmente, primero voy a
1:52 comentarles un poco acerca de la forma en la que desarrollaba aplicaciones tan
1:55 solamente un par de años atrás. Y bueno, aquí tenemos un diagrama que lo
1:58 representa de una forma sencilla y es que antes yo desarrollaba aplicaciones
2:02 de frontend por separado en donde teníamos, por ejemplo, una aplicación
2:06 web que estaba desarrollada con BJS o algún tipo de generador de frontend. Y
2:10 bueno, esto se combina con algún backend. Obviamente el backend en lo
2:13 personal para ese tipo de proyectos en donde queremos que todo se cargue muy
2:17 rápido y sea bastante simple desarrollar también pues es mejor tenerlo por aparte
2:21 el backend. En este caso, las redes API, que es una forma bastante típica de
2:24 crear aplicaciones, la desarrollado utilizando express y combinado con
2:28 alguna base de datos. Y en realidad es esta stack es simple y aún es válido,
2:32 obviamente. Es decir, nosotros podemos seguir desarrollando utilizando esta
2:35 misma idea. Y claro, incluso esta es la forma en la que muchos prefieren
2:37 hacerlo, principalmente porque prefieren tener, digamos, los entornos separados
2:41 de backing y frontend. El tema es que cuando queremos crear una aplicación
2:44 rápida para un cliente, queremos tener la forma en la que ya queremos
2:47 integrarlo dentro de un entorno y que empiece a funcionar, probablemente no
2:51 vamos a estar queriendo tener más trabajo dividiendo dos proyectos y
2:54 manejando dos entornos distintos, porque incluso hasta la API puede ser un
2:58 framework por aparte, es decir, puede ser JJo, Larabel, Nes o cualquier otro
3:03 tipo de framework dedicado solo al backend. Entonces, solo para tenerlo
3:06 claro, actualmente tanto para desarrollar el backend como el frontend,
3:10 y si quieren hacerlo de una forma rápida, es preferible utilizar un
3:13 framewor full stack. En mi caso, por ejemplo, yo estoy utilizando estos días
3:16 NextJS. Y bueno, la razón de utilizar NextJS no es tanto por un tema de
3:20 preferencia personal, sino porque simplifica mucho de las tecnologías que
3:23 ya utilizamos a diario. Es decir, si desarrollas proyectos de backend en and
3:26 en node y frontend en React, es probable que en ya se simplifique mucho más el
3:30 desarrollo porque permite integrar a ambos dentro de un mismo framework. Es
3:33 algo así como tener finalmente un framework que permite hacer tanto
3:36 backend y frontend en el mismo código o en el mismo proyecto e incluso hasta
3:40 pueden compartir lógica, por ejemplo, de validaciones o de bibliotecas que se
3:44 pueden ejecutar tanto frontend backend. Y bueno, en realidad Nexus es un
3:47 framework bastante popular y casi la mayoría de generadores de ella lo está
3:51 utilizando actualmente cuando piden sugerir algún proyecto que lleve backend
3:55 y también API, pero no es el único obviamente de hecho también tiene
3:58 algunas opciones alternativas. Por ejemplo, esta Tang Stack Start, que es
4:01 un proyecto open source que es relativamente nuevo, pero que en sí
4:05 tiene la misma idea de NextJes, en el sentido que poseen routing, también
4:08 posee funciones de servidor al mismo estilo de crear tu propia IPI congs.
4:13 Tiene los mismos conceptos como middlewares y también tiene
4:16 configuraciones para poder hacer que la página sea estática o al momento de
4:20 generarse estática o también se puede actualizar con incremental static
4:23 regeneration. Es decir, estos son métodos de renderizado, que incluso yo
4:27 ya les he explicado en el video de métodos de renderizado del frontend, así
4:31 que les recomiendo y se lo dejo aquí en la descripción. El único tema es que
4:33 Tang Stack al ser relativamente nuevo no hay mucha información y si bien algunos
4:36 están mudando a Tang Stack Star, este no es un proyecto al mismo nivel de Next,
4:41 pero sí es bastante prometedor en el sentido de que su equipo de desarrollo
4:44 sí está mucho más preocupado en la calidad del código y que tan estable
4:48 puede hacer. A diferencia de Nex, que por lo general siempre trata de añadir
4:51 más características y más características y justo en estos últimos
4:54 meses ha tenido algunos fallos de seguridad, pero bueno, por el resto,
4:56 obviamente ellos también están detrás y van parchando estos errores, pero esto
5:00 es un proyecto que si quieren tener algo alternativo, next y similar, es decir,
5:03 Read, frontend, note backend, esto es lo más prometedor de este año. Aunque si en
5:07 su caso a ustedes no les interesa el framework de Read en el frontend,
5:11 ustedes pueden cambiarlo con Spell, por ejemplo, que también es otra alternativa
5:14 bastante común estos días. La diferencia con Spell es que obviamente no utiliza
5:19 JSX y ni siquiera utiliza un don virtual. Esto se compila, es decir,
5:23 tiene un compilador que convierte código. Aunque las últimas versiones de
5:26 ReN incluyendo su propio compilador, esto lo tuvo como primera idea.
5:30 Adicionalmente a esto, también ellos tienen un framework que se llama spell
5:34 kit, que tiene la misma idea de Next y es decir, también permite crear código
5:38 de node de backend combinado con framewor de frontend, que sería Sell. Y
5:42 la misma idea con views, si a ustedes les gusta más view y quieren tener lo
5:45 mismo, NAJS también es un framework que hace una idea similar, es decir, también
5:50 permite generar aplicaciones backend frontend, solo que en ese caso el
5:53 framework sería view en el frontend. Y bueno, este sí es un proyecto bastante
5:56 conocido e incluso muchos prefieren utilizar este framework porque también
6:00 añade sus propios conceptos e incluso va a la par con es decir no es como tanta
6:05 que es un proyecto relativamente nuevo y bueno, no todas las características
6:08 están, sino que en NAS ya están hechas e incluso muchas veces Next también ha
6:12 utilizado algunas ideas de Nax y viceversa y finalmente no es un
6:15 metaframewor, de hecho no nació como uno, principalmente es un generador de
6:19 sitios estáticos, pero en la práctica cuando lo llegan a utilizar Astro se
6:22 parece un poco a un metaframework en el sentido de que también permite crear
6:26 lógica de backend y también tener código de frontend e incluso en múltiples
6:30 lenguajes. Pero bueno, eh lo menciono simplemente por el hecho de que también
6:33 permite ejecutar lógica de frontend en múltiples frameworks. Aunque bueno, por
6:37 la definición no sería exactamente un metaframework. También vale la pena
6:40 mencionarlo si en caso quieren utilizar una alternativa más. Pero por el resto
6:44 de opciones que les he mencionado sí son metaframewors y obviamente también hay
6:47 en otros frameworks como por ejemplo Angular, pero estos son los más
6:49 populares. Y bueno, les digo todo esto porque justamente en la forma en la que
6:53 actualmente estoy desarrollando proyectos, principalmente estoy usando
6:55 NextJES. Entonces, en lugar de hablarles de un framework de frontend y backend
6:59 por aparte, voy a hablar de las características principales que uso en
7:02 cada uno. Principalmente en el frontend algo que utilizo bastante es obviamente
7:05 el server side rendering, que justamente en estos últimos meses es el que más
7:09 fallo de seguridad ha tenido. Creo que he tenido como dos en solamente dos
7:12 semanas. Pero esto es muy importante cuando ustedes crean algún proyecto en
7:15 el que necesiten principalmente SEO y una carga rápida. Además también un
7:19 control de las páginas de lado servidor. Y bueno, el día de hoy igual tengo que
7:22 seguir utilizándolo porque esa es la forma al parecer estándar estos días,
7:26 aunque obviamente hay características que no utilizo. Por ejemplo, en cuanto
7:29 al frontend, yo no escribo lógica que esté combinada con el backend. Yo, por
7:32 ejemplo, no uso server actions ni lógica similar, sino que yo prefiero utilizar
7:36 lo que serían las redes API, es decir, crear rutas, crear URLs y que el front
7:41 las consulte. La razón es que justamente al crear las redes API con route
7:45 handlers, que es como le llaman next, si a futuro el proyecto crece o les va bien
7:49 o necesitan separarlo, el backen al estar escrito en rutas y el front en el
7:53 consultarlas, simplemente van a poder mover esta lógica por aparte. Es decir,
7:57 no como copiar archivos, sino basando en el diseño, ustedes pueden crear rutas o
8:01 URLs muy similares. Por otra parte, si utilizaran Server Actions, tendrían que
8:06 crear la IPI desde cero y eso es mucho más trabajo incluso porque las server
8:10 action son prácticamente funciones nada más. Y bueno, otro trabajo que hacen las
8:13 server actions, obviamente es que también crean la IP por detrás, pero
8:16 justamente ese tipo de lógica es la que a veces causa muchos errores porque es
8:19 algo relativamente nuevo y en lo personal no creo que el server action
8:22 sea muy utilizado a comparación de las redes API. Lo otro que también utilizo
8:26 en el mismo proyecto de frontend son los static side Generations, que es
8:29 prácticamente el HTML generado desde NextJES. Es decir, no todas las páginas
8:33 necesitan ser interactivas. Si ustedes van a tener un landing page en ese
8:36 proyecto, probablemente puede ser estático. Entonces, algo que deben
8:39 preocuparse cuando están utilizando IA, que al día de hoy es muy común de saber
8:43 que la gran mayoría utiliza IA para generar código, es que la IA no genere
8:46 todo el código utilizando simplemente use client, porque esto es lo mismo que
8:50 utilizar BJS, por así decirlo. Entonces, si ustedes van a estar utilizando las
8:53 características que les ofrece un framework, pues usen justamente eso. No
8:56 traten de utilizar simplemente lo que les dé la IA y el trabajo está en saber
8:59 revisar y saber si realmente necesitamos ese método de renderizado. Y en cuanto
9:03 al backend, no es algo de NS netamente, pero algo que se combina bastante bien
9:06 es justamente el uso de un ORM. En este caso, actualmente, yo estoy utilizando
9:10 Prisma, pero bueno, esto no es un concepto netectamente de NS, de hecho es
9:14 un paquete por aparte que se relaciona con NS en el backend, así que podríamos
9:17 colocarlo fuera del ecosistema frontend backend, pero obviamente esto está
9:21 conectado con las redes API del backend. Ahora, el ORM en este caso puede ser
9:25 también otro, puede ser drzel, aunque esto es lo que utilizo actualmente para
9:29 crear un proyecto de forma rápida. Y en cuanto a la base de datos, si bien el
9:32 ORM te permite escoger entre múltiples bases de datos de SQL, la que estoy
9:35 utilizando bastante al día de hoy es postre SQL. La principal razón es que en
9:39 postre SQL es bastante fácil encontrar hosting, por así decirlo. Es decir, si
9:43 quieres desplegar tu base de datos en la realidad, hay muchas plataformas de la
9:46 nube que te permiten hacerlo. Por darles una idea, hay una plataforma que se
9:50 llama Neon, que es una forma automática de crear una base de datos.
9:53 Prácticamente te creas una cuenta, te dan una dirección y listo, ya tienes una
9:56 base de datos desplegada en producción. El tema está en que, claro, estas
10:00 plataformas siempre tienen un costo y no son baratas. De hecho, la gran mayoría
10:03 te cobra por uso o te cobra a partir de los 20 hacia arriba, solamente la base
10:07 de datos. Entonces, deben tener en cuenta también esto. De hecho, si
10:10 ustedes buscan algo como esto en Google Postres Cloud Services list o o lista de
10:14 servicios de en la nube, van a ver que casi todas las nubes poseen hosting de
10:17 postre SQL, por ejemplo, AWS, Microsoft Asure e incluso hay servicios externos
10:23 como Supabase o Elephan SQL que permiten desplegar postres de forma automática.
10:27 Y bueno, es la razón principal de por qué escoger postre SQL. Además que es un
10:31 proyecto que obviamente es netamente open source, continuamente lo van
10:35 actualizando, tiene una comunidad activa y al ser un entorno tan utilizado
10:39 ustedes van a poder luego continuar aprendiendo más de solamente postre SQL,
10:42 es decir, si luego quieren evitar el uso del ORM y directamente hacer consultas
10:45 de SQL, el aprender podre es relativamente simple. Y bueno, solo con
10:48 esto ustedes ya se dan cuenta que tenemos frontend, backend y base de
10:51 datos. Es decir, ya llegamos a prácticamente a este mismo esquema
10:55 solamente utilizando un solo framework y un solo módulo. Esto simplifica bastante
10:58 este tipo de proyectos cuando se tratan de clientes que quieren un proyecto muy
11:02 rápido o quieren prototipar algo. Esta es la forma en la que prefiero
11:05 desarrollar proyectos estos días. Ahora, no todo es puramente código, también se
11:09 necesita aspectos visuales o funcionales en cuanto al frontend. Y aquí, por
11:13 ejemplo, nosotros podríamos mencionar a Chat CN. Al momento que estoy grabando
11:16 esto, Chat CN es prácticamente el estándar para crear interfaces web en la
11:20 mayoría de proyectos. Incluso si le pides a una IA a que te genere
11:23 interfaces, es muy probable que utilice esta biblioteca. La razón es que a este
11:27 momento Chats 100 tiene la mayoría de componentes comunes que todo proyecto
11:31 necesita, desde avatar prediseñados, tarjetas para que puedas incluirlas,
11:35 formularios, botones e incluso también tiene componentes más avanzados como
11:39 pueden ser por ejemplo un command picker. El tema está en que utilizar
11:42 esta biblioteca es relativamente cómoda porque si ustedes quieren hacer que una
11:45 UI se vea bien y sea funcional principalmente, el utilizar Chat
11:49 simplifica mucho las cosas porque no nos preocupamos tanto en utilizar nuevamente
11:53 CSS, HTML, hacer que luzca tal cual nuestro interfaje queremos, sino que
11:57 probablemente vamos a instalar un componente y simplemente lo
12:00 personalizamos. Entonces, para cosas muy común, proyectos muy comunes que se
12:04 quieren acabar rápido, podemos utilizar este conjunto de componentes. Esto se
12:07 llama UI Library y también, obviamente, podemos alterar los colores o el diseño.
12:11 E incluso también tiene componentes mucho más avanzados como son sidebars,
12:15 por ejemplo, que pueden estar en distintos formatos o páginas de login
12:19 dentro de su propia documentación y todo el código es completamente accesible e
12:22 incluso hasta pueden ejecutarlo con un comando, todo ese tipo de diseño. Ahora,
12:26 en cuanto a los formularios, que es una parte muy importante del frontend, allí
12:30 sigue utilizando una biblioteca que se encarga de manipular los estados del
12:34 formulario y es Read Hook Form. Y esta típicamente se combina con otra
12:38 biblioteca que solamente valida datos y que también funciona en el backend que
12:42 se llama SOT, es decir, se pueden combinar ambas dentro del backend y el
12:46 frontend o incluso hasta se pueden reusar. El único tema está en que
12:49 obviamente necesitas considerar la lógica en cuanto al tipo de dato o la
12:53 fórmula que se ejecuten. Pero bueno, aquí es justamente un ejemplo de cuando
12:57 hablo que se puede utilizar una lógica de validación si es backend y frontend.
13:01 Es decir, si el backend está esperando cierto objeto y el el formulario también
13:06 espera cierto objeto, no es necesario crearlo dos veces. Pueden crear una sola
13:10 vez e importarlo. Ahora, en cuanto a lógica para subida de archivos,
13:13 típicamente ustedes quizás crean que se guarda en la base de datos. De hecho,
13:17 también es posible. El único tema es que por lo general no es tan buena idea
13:21 sobrecargar la base de datos con un tipo de archivo que llega a pesar mucho más,
13:25 se tiene que consultar y hace también más complejas las consultas en cuanto a
13:29 código. Entonces, una forma muy común estos días de crear aplicaciones y
13:33 alojar archivos para esas aplicaciones es justamente utilizar un servicio de
13:37 alojamiento de archivos por separado. Y bueno, allí en lo general también al
13:41 igual que hacemos con el despliegue de póstres, también necesitamos una nube
13:45 que guarde los archivos. Y en lo personal, algo que yo utilizo
13:48 simplemente por el costo es una plataforma que se llama Spaces, es
13:52 decir, no desplegado todo el backen allí, simplemente utilizo lo que sería
13:57 su servicio para alojamiento de archivos. La razón principal de utilizar
14:01 este servicio es que justamente necesitamos ver el precio cuando
14:04 alojamos archivos y este nos permite por $5 alojar 250 GB. Y claro, si pasamos
14:10 este límite, vamos a tener que añadir 0,02avos
14:14 de dólar por gigabte al mes. Y en realidad esto lo hace una opción muy
14:17 barata para alojar archivos, porque si tu aplicación necesita alojar PDFs,
14:21 imágenes, videos y quieres tener un entorno donde se carguen rápido y
14:26 obviamente un sistema para poder almacenarlos, esa es de las formas más
14:29 sencillas. Además, algo que también tiene en cuanto a ventaja es que es
14:33 compatible con S3. Para aquellos que no saben qué es S3, S3 es un servicio de
14:38 AWS en donde también se alojan archivos y la gran mayoría preferiría utilizar
14:43 ese servicio, solamente que puede llegar a ser mucho más caro y cobran por uso,
14:48 pero para proyectos que eh recién empiezan y eventualmente van a tener una
14:52 enorme cantidad de archivos que van a almacenar, es mucho mejor tener uno de
14:56 estos servicios porque te cobra de una forma fija, al menos ese inicio. Pero
15:00 bueno, S3 también tiene un tier gratuito que le regala algo de almacenaje al mes,
15:04 pero por lo general simplemente por la simplicidad y poder tener entornos de
15:08 producción, este me parece mucho más accesible. Y bueno, también les digo que
15:12 es compatible principalmente porque si escriben lógica para poder subir
15:16 archivos. Luego si deciden pasarse a S3 es tan fácil como cambiar la dirección
15:20 simplemente y el resto va a seguir funcionando igual. Eso significa que es
15:23 compatible con S3. Luego, en cuanto a la característica de emailes
15:27 transaccionales o correas transaccionales, por lo general utilizo
15:32 también un servicio que es relativamente barato e incluso tiene un plan gratuito
15:37 que le regala como 300 emails al día, que se llama brevo. Lo mismo también hay
15:42 otros servicios que son gratuitos o hay algunos que vienen por parte de WS.
15:46 Brev. Lo que hace es justamente simplificar el proceso de envío de
15:51 correos o SMS, es decir, si ustedes necesitan enviar un correo de forma
15:56 automática sin la necesidad de configurar, por ejemplo, su propio
16:00 servidor SMTP. Esta es de las formas más sencillas. Además, también tienen
16:04 automatizaciones y otras cosas incluidas como seguimiento del cliente, es decir,
16:08 una plataforma CRM. Pero no lo utilizo tanto por eso, simplemente lo utilizo
16:13 por la plataforma de envío de correos. Y de hecho, si venimos en los precios,
16:17 vamos a ver que por lo general tiene un plan desde 8, pero gratuitamente, es
16:22 decir, de forma simplemente con registrarnos, nos dan 300 correos al día
16:26 que podemos enviar. Además, si eventualmente necesitan enviar mensajes
16:30 de WhatsApp o de SMS, también la plataforma posee un integrador.
16:34 Entonces, también pueden utilizarlo desde aquí. Y bueno, el tema está en que
16:38 es una plataforma separada, es bastante de empezar a utilizarlo y no requiere
16:42 que coloquemos tarjeta de crédito ni nada de eso, solamente nos queramos una
16:46 cuenta y ya estaría. Ahora, en cuanto a la autenticación, que es un proceso muy
16:49 importante y todas las aplicaciones de cierta forma llevan algún método de
16:53 autenticación o registros, por lo general lo que estoy utilizando más hoy
16:57 día es out. Beterout es un paquete relativamente nuevo, es decir, a
17:02 diferencia de Next o outJS, que es como lo que utilizaba bastante en los años
17:07 anteriores, esta biblioteca es mucho más cómoda de configurar y no tiene tantos
17:11 errores como pasa con outGS. Al ser nueva también han tomado en cuenta mucho
17:15 de los errores que pasan anteriormente e incluso hasta tienen algunas
17:17 innovaciones como integrarlo con MCPs o posee formas en las que una IA puede
17:23 entender cómo se ha integrado la autenticación en el sistema utilizando
17:26 este archivo llamado llms.txt. Es como que una entra y puede leerlo. De
17:30 hecho, algo que deben saber es que esta no solamente se incluye para NextJS,
17:34 sino que es framework agnostic, es decir, no está relacionada con un
17:38 framework en específico y puede trabajar prácticamente con cualquier framework y
17:42 también se puede extender mucho más fácil porque también tiene un sistema de
17:45 plugins, así que a medida que aparezcan quizás nuevas plataformas para
17:48 integrarse es mucho más fácil de añadirlas y también eso significa que
17:52 ustedes pueden integrarlo directamente con cualquier base de datos o adaptador
17:55 o RM como puede ser Drizel, Prisma y demás. Es decir, de cualquiera de esos
17:59 metaframewor que les mencioné pueden ser integrados con Vederados fácilmente.
18:03 Ahora, a partir de aquí estoy seguro que ustedes van a querer añadir más
18:06 bibliotecas, pero estas son de las más comunes, es decir, todo sistema lleva
18:10 una forma para mostrar páginas con buen SEO, páginas que carguen rápido,
18:15 páginas con lógica de frontend que permitan manejar formularios, que
18:19 permita hacer autenticación, subida de archivos e enviar correos transaccionales.
18:24 No les he mencionado, pero enviar un correo transaccional significa que
18:29 ustedes envían un correo, por ejemplo, cada vez que el usuario compra algo,
18:33 cada vez que quiere reiniciar su contraseña o cada vez que hace algún tipo
18:37 de acción y ustedes quieren notificarle por correo. Esta es las formas típicas
18:41 en las que se hace. Pero de hecho, hablando de los pagos, aquí no lo menciona
18:45 específicamente porque dependiendo del cliente o del proyecto que hagan, el
18:50 entorno de pagos varía. Por ejemplo, Latinoamérica no está disponible Stripe
18:55 sin tener una cuenta de Estados Unidos, entonces es mucho más difícil
18:59 mencionarlo aquí. Y por ejemplo, aquí podríamos hablar de otras opciones como
19:03 pueden ser eh Mercado Pago o PayPal o también proveedores de cada país porque
19:09 cada país tiene sus propios proveedores que están en sus propias monedas.
19:14 Entonces no es tan común que les mencione, pero obviamente casi todos los
19:17 proyectos llevan algún tipo de modelo de servicio o de suscripción o similar.
19:22 El tema está en que para desplegar todo esto, obviamente tiene que ir en algún
19:26 entorno y para cerrarlo, obviamente la gran mayoría de ustedes ya sabe que yo
19:30 el entorno que utilizo como nube es railway. La razón principal de por qué
19:35 utilizo Raywell no solamente es por la facilidad de despliegue o porque también
19:40 es bastante rápido para desplegar proyectos, sino principalmente lo uso
19:44 por el tema de que casi todo el proyecto puede estar aquí. Es decir, no tan
19:48 solamente despliegas el frontend, el backend, sino también la base de datos.
19:52 Entonces, luego te crea estos diagramas en donde esto es por proyecto. Allí
19:56 puedes ver cómo está todo el proyecto resumido. Y como tiene formas de
20:00 integrar también otros servicios como redis o contenedores de Docker, puedes
20:04 ir expandiéndolo y ya te cobran por uso. Obviamente esto en cuanto al propio
20:08 display de un bps puede sonar mucho más caro, pero en realidad al momento que
20:13 inicie tu proyecto no lo notas casi. Lo notaría si tienes un alto consumo de
20:17 ancho de banda o tienes un alto consumo, por ejemplo, de interacciones o consumo
20:21 de CPU o consumo, por ejemplo, de RAM y así, que eso ya viene a partir del
20:26 código. Pero bueno, en la gran mayoría de clientes que he tenido, clientes
20:30 normales que por ejemplo utilizan diariamente y tienen algunos usuarios al
20:34 día que usan una aplicación, a ver puede rondar desde los $10 al mes y de esa
20:39 forma tienes todo un proyecto funcionando en producción. Y bueno, de
20:43 la forma personal es bastante cómodo desarrollarlo porque ya tienen en torno
20:47 6 CD incluidos, es decir, solo conectas tu GitHub, haces un push y ya todo se
20:51 actualiza. Puedes crear también o replicar el entorno de producción o un
20:56 staging. Entonces, casi la mayoría de funcionalidades comunes ya las tienen
21:00 hechas. Los precios empiezan desde $ al mes y si ustedes no tienen una cuenta y
21:04 es la primera vez que se registran, también pueden utilizar el enlace que
21:08 les dejo en la descripción y les va a dar 20 gratis para que puedan utilizarlo
21:13 en consumo, además de un mes gratis también para que puedan iniciar con su
21:17 proyecto. Y bueno, ese sería el resumen del stack para poder crear aplicaciones
21:21 muy comunes. La gran mayoría de proyectos puede llegar a funcionar de
21:25 esta forma y, incluso a partir de esto ustedes pueden seguir evolucionándolo,
21:29 es decir, no se estanca solamente en tener un solo proyecto y tenemos que
21:33 continuarlo de esta forma porque también obviamente tiene desventajas, es decir,
21:37 si ustedes van a crear por ejemplo una R API, con la pueden hacerlo y pueden
21:42 consumirlo también de aplicaciones móviles, pero algo que no se puede hacer
21:46 fácilmente es, por ejemplo, API de Web Sockets, donde allí sí vas a necesitar
21:51 un servidor por aparte. Lo mismo si vas a desarrollar una graph qlp, no vas a
21:56 poder tener el entorno aquí dentro de los route handlers, es decir, si puedes
22:01 consumir los del frontend, obviamente del front si puedes conectar a web
22:05 socket o grafq, pero crear el servidor de grafq o el servidor de web Socket no
22:10 lo vas a poder hacer aquí. Y bueno, adicionalmente a esto es que en NextJ
22:14 también tenemos una forma de crear archivos y rutas, es decir, no podemos
22:18 adaptarlo a la forma en la que queramos. Así que es probable que si ustedes van a
22:22 crear un backend y necesitan tener un poco más de orden o quieren tener algún
22:26 tipo de forma de organizar archivos, incluir por ejemplo documentación para
22:30 la red API o tener múltiples versionados y todo aquello, es mucho más fácil de
22:34 hacerlo en un framework de backend. Es decir, NextJS no es un framework de
22:39 backend. Inicialmente es un framework de frontend que al añadirle note por detrás
22:44 también les dio la posibilidad de crear algo de backend. Pero si quieren
22:48 características más avanzadas de un backend, es mucho más recomendable
22:52 moverlo por aparte. Entonces el tema está en que cuando yo tengo algún
22:56 cliente, por lo general no se preocupa mucho en eso porque no van a estar
23:00 creando una aplicación móvil por aparte, no requieren versionados. Entonces por
23:04 lo general hacerlo dentro de la misma IPI es mucho más fácil y eventualmente
23:09 cuando quieran ese tipo de lógicas se puede mover todo lo que les he dicho. Es
23:13 decir, al crearlo en Rout handlers van a poder moverlo a otro framework. Y para
23:18 terminar todo esto, algo que no he mencionado, pero es más que obvio que
23:22 todo el mundo lo utiliza al día de hoy, es el uso de alguna IA. Y en lo
23:26 personal, estos días ya no utilizo tanto lo que es un editor de código. De hecho,
23:30 en videos anteriores yo les he mencionado bastante que utilizaba Cursor
23:33 en su versión pagada. Bueno, ya yo no pago por cursor, pero algo que sí pago
23:38 es el uso de cloud code o digamos los modelos de cloud, principalmente porque
23:42 casi todas estas porciones de código que les he mencionado, todo se puede generar
23:47 con cloud. Ahora hay modelos como Cloudset o últimamente Cloud Opus, pero
23:52 ustedes pueden llegar a crear cualquier tipo de estos proyectos, obviamente
23:56 sabiendo qué es lo que va en cada uno, utilizando cloud. Y bueno, en la
24:00 descripción también les dejo bastantes recursos de cloud, de hecho tengo una
24:04 lista de reproducción solamente utilizar cloud en donde van a aprender cómo
24:08 configurarlo, las bases, además de también una demostración práctica de
24:12 cómo creo un proyecto de este estilo utilizando cloud. Todo eso los dejo en
24:16 la lista de reproducción que lo va a encontrar en la descripción. Y nada más
24:20 que eso, en realidad utilizando este stack es mucho más sencillo acabar con
24:25 proyectos de una forma barata y bastante rápido. Es decir, no necesitamos crear
24:29 un frame por aparte, un back por aparte. Y de hecho si ustedes se preguntan de
24:33 qué forma se han estado creando la enorme cantidad de servicios de IA en
24:37 estos últimos años, la gran mayoría está utilizando este stack prácticamente. Y
24:41 lo genial es que justamente como se ha usado mucho eh los modelos inteligentes,
24:46 pueden llegar a generar este stack de una forma bastante rápida. Y obviamente
24:50 no es que lo haga todo, porque igual ustedes tienen que revisar que lo haga
24:54 utilizando estos conceptos que les he dicho, eh, páginas de lado servidor,
24:58 páginas de lado frontén, así que igual tienen que ir revisando todo lo que va
25:02 creando, pero obviamente es una mejora enorme en cuanto a productividad. Esto
25:06 les menciono porque ya estamos hablando de crear proyectos, no estamos hablando
25:10 de alguien que empieza a aprender a programar. Si ustedes ya saben
25:13 programar, probablemente este stack es el que se lo recomienda, es muy rápido,
25:17 es bastante fácil generar aplicaciones, pero si recién están empezando a
25:21 aprender, a programar o desarrollar, no utilicen esto. Esto se salta todo el
25:25 proceso de aprendizaje y no va a llegar a conocer nada, no van a luego saber
25:29 cómo extenderlo. Entonces, lo ideal es que aprendan las bases y ya luego cuando
25:33 sepan las bases pueden empezar a optimizar el tiempo. Si no saben qué
25:36 hacer, no hay nada que optimizar prácticamente. En fin, como pueden ver,
25:40 para aprender a desarrollar una aplicación de forma rápida y barata,
25:43 esos son algunas formas bastante comunes de poder crear aplicaciones. En realidad
25:46 hay muchos más temas que quizás van a querer añadir o cambiar, pero esto es lo
25:50 único que yo utilizo estos días para poder crear aplicaciones, sobre todo
25:54 cuando se tratan de proyectos pequeños. Ya cuando hablamos de proyectos más
25:57 grandes, cuando tenemos un backend por aparte, aplicaciones móviles o distintos
26:01 frontends, obviamente este stack no sirve para eso. De hecho, hay quien
26:04 utiliza en lugar de crear su propio back en Supase. Y en este caso yo no utilizo
26:08 eso, pero ustedes también pueden optar por ese tipo de entornos que es bastante
26:12 estable y de nuevo también es una muy buena opción, aunque claro, si ustedes
26:15 quieren ver el stack que utilizo típicamente para una empresa pequeña que
26:19 tiene todo por aparte y ordenado, también hay otro video que ya publiqué
26:22 hace muchos meses atrás en donde les mostraba cuál es el stack más simple que
26:26 utilizaba para ese tipo de casos y también se los voy a dejar en la
26:28 descripción. En fin, eso ha sido todo por el video del día de hoy. Si tienen
26:32 una duda pueden dejar en los comentarios y nos vemos en un siguiente video. Eso
26:35 ha sido todo por el video del día de hoy. Si tienes dudas puedes dejarla en
26:38 los comentarios o en la descripción dejo un enlace para que te puedas unir a la
26:41 comunidad de Discord en donde encontrarás a otros desarrolladores o si
26:44 en caso el enlace está caído, puedes ir a fast.df/discord para acceder más
26:49 rápidamente. Dejo mi Twitter donde típicamente comparto algunos recursos
26:52 interesantes de desarrollo y programación en general. Mi Instagram donde
26:56 comparto algunas noticias cortas todos los días. el TikTok donde comparto
27:00 videos cortos e informativos y mi canal principal en donde comparto
27:04 opiniones y noticias de tendencias nuevas. Además, también dejo mi web en
27:07 donde puedes reservar asesorías personalizadas. Gracias por ver y nos vemos
27:11 en un próximo