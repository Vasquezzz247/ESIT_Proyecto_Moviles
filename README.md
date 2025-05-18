# Control de Gastos 📱💸  
Aplicación Flutter **3.29.x** para registrar, consultar y administrar tus gastos personales totalmente **offline** mediante SQLite.

## Tabla de contenido  
1. **Demo**  
2. **Instalación rápida**  
3. **Estructura del proyecto**  
4. **Flujo de pantallas**  
5. **Stack técnico**  
6. **Pruebas**  
7. **Roadmap**  
8. **Autor**  
9. **Licencia**

---

## Demo  
[Video en YouTube](https://youtu.be/XXXXaagregar_linkXXXXXXX)

---

## Instalación rápida  

| Paso | Comando |
|------|---------|
| Clonar repo | `git clone https://github.com/<TU_USUARIO>/ESIT_Proyecto_Moviles.git` |
| Instalar dependencias | `cd control_gastos && flutter pub get` |
| Ejecutar en dispositivo | `flutter run` |
| Build APK release | `flutter build apk --release` |

---

## Estructura del proyecto

    lib
    ├─ core
    │  ├─ db           # DBHelper (SQLite)
    │  └─ models       # Entidades de dominio
    ├─ providers       # Gestión de estado (Provider)
    ├─ ui
    │  ├─ pages        # Home, Movimientos, Detalle
    │  ├─ widgets      # FAB, BottomNav, Cards
    │  └─ theme        # Light / Dark
    └─ main.dart       # Bootstrap + rutas
    test
    └─ db_helper_test.dart

Patrón **Presentation → Provider → Data**  
- Se consulta la BD una sola vez y se cachea en memoria con Provider.  
- La interfaz se actualiza usando `notifyListeners()`.

---

## Flujo de pantallas

| Pantalla | Componentes | Funcionalidad |
|----------|-------------|---------------|
| **Inicio (Resumen)** | SliverAppBar, Card, Provider.total | Muestra total gastado y acceso a Movimientos |
| **Movimientos** | CustomScrollView, GastoCard, CustomFAB (Hero) | Lista de gastos, alta, edición y eliminación |
| **Bottom-sheet** | Form, Dropdown, DatePicker | Formulario validado con fecha personalizable |
| **Detalle** | CustomActionButton | Vista individual con “Editar” y “Eliminar” |

---

## Stack técnico  

| Capa | Tecnología | Propósito |
|------|------------|-----------|
| UI | Material 3, Slivers, Hero | Diseño responsivo Light/Dark |
| Estado | Provider 6 | Reactividad simple |
| Persistencia | sqflite 2 + path | SQLite local |
| Utilidades | intl, collection | Formato de fecha y helpers |
| Tests | flutter_test, sqflite_common_ffi | CRUD en memoria |

---

## Pruebas

    flutter test

El test **db_helper_test.dart** cubre insertar, leer, actualizar y eliminar registros en una base de datos temporal (en memoria).

---

## Roadmap

- Filtros por fecha y categoría  
- Gráficas (fl_chart)  
- Exportar a CSV/Excel  
- Backup opcional en Firebase  
- Versión iOS / Desktop  

¡Pull Requests bienvenidos! 🥳

---

## Autores

**Julio Quezada** · Desarrollador Full Stack

LinkedIn: [Julio Quezada](https://www.linkedin.com/in/quezadajulio/)

GitHub: [Julio Quezada](https://github.com/Alejandroq12)

**Alejandro Vasquez** · Estudiante de Ingeniería Informática

GitHub: [Alejandro Vasquez](https://github.com/Vasquezzz247)

---

## Licencia  

MIT © 2025
