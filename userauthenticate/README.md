Documentación del Proyecto

Requisitos Previos
Antes de comenzar, asegúrate de tener instalados los siguientes componentes en tu máquina:

1- Node.js: Necesario para ejecutar el servidor.
2- Flutter: Necesario para compilar y ejecutar la aplicación móvil.
3- Editor de Código: (Opcional) Un editor como Visual Studio Code o Android Studio para editar el código.

Estructura del Proyecto

Tu proyecto contiene dos partes principales:
1- Servidor Node.js: Responsable de manejar la lógica de backend y las solicitudes HTTP.
2- Aplicación Flutter: Cliente móvil que interactúa con el servidor.

Levantar el Servidor Node.js

1- Navegar a la carpeta del servidor: Abre una terminal y navega a la carpeta donde se encuentra tu servidor Node.js.
    cd /ruta/a/tu/servidor
2- instalar las dependencias: Si no lo has hecho aún, instala las dependencias necesarias ejecutando el siguiente comando:
    npm install
3-Levantar el servidor: Inicia el servidor ejecutando:
    node server.js
Nota: Asegúrate de que server.js sea el archivo principal de tu servidor. Cambia el nombre si es necesario.


Verificar que el servidor esté funcionando: Abre tu navegador y dirígete a http://localhost:3001 (o el puerto que esté utilizando tu servidor) para verificar que esté funcionando.

Levantar la Aplicación Flutter

1- Navegar a la carpeta de la aplicación Flutter: En otra terminal, navega a la carpeta de tu proyecto Flutter:
    cd /ruta/a/tu/app
2- Instalar dependencias: Ejecuta el siguiente comando para asegurarte de que todas las dependencias estén instaladas:
    flutter pub get
3- Configurar la URL del servidor en Flutter: Asegúrate de que en tu código Flutter (por ejemplo, en la función que realiza la solicitud HTTP) estés utilizando la dirección IP de tu máquina, en lugar de localhost. Por ejemplo:
    final response = await http.post(
    Uri.parse('http://192.168.x.x:3000/api/register'), // Reemplaza x.x con tu IP y el puerto correcto
    body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
    }),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
    },
    );
4- Ejecutar la aplicación: Puedes ejecutar la aplicación en un emulador o dispositivo físico usando el siguiente comando:
    flutter run
5-Probar la aplicación: Abre la aplicación en tu emulador o dispositivo físico y prueba las funcionalidades que interactúan con el servidor Node.js.

Conexión entre el APK y el Servidor

La aplicación Flutter se conecta al servidor Node.js a través de solicitudes HTTP. Asegúrate de que:
    1-El servidor esté en ejecución antes de ejecutar la aplicación Flutter.
    2-La dirección IP del servidor esté correctamente configurada en tu código Flutter para que apunte a la máquina que está ejecutando el servidor.


Notas Finales
    Errores Comunes: Si encuentras problemas de conexión, verifica tu firewall y asegúrate de que el puerto que usa tu servidor esté accesible.
