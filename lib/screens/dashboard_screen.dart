import 'package:flutter/material.dart';
import '../models/orden_trabajo.dart';
import '../models/usuario.dart';
import '../data/dummy_data.dart';
import '../data/usuarios_dummy.dart';
import '../services/auth_service.dart';
import 'detalle_ot_screen.dart';
import 'nueva_ot_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

enum OrdenamientoOT {
  masReciente,
  masAntigua,
  prioridadAlta,
  prioridadBaja,
}

class _DashboardScreenState extends State<DashboardScreen> {
  EstadoOT? _filtroEstado;
  TipoFalla? _filtroTipoFalla;
  Prioridad? _filtroPrioridad;
  String? _filtroTecnicoId;
  String _textoBusqueda = '';
  bool _mostrarFiltrosAvanzados = false;
  OrdenamientoOT _ordenamiento = OrdenamientoOT.masReciente;
  final List<OrdenTrabajo> _ordenesTrabajo = List.from(ordenesTrabajosDummy);
  final _authService = AuthService();
  final _searchController = TextEditingController();

  List<OrdenTrabajo> get _ordenesFiltradas {
    var ordenes = _ordenesTrabajo;

    // Filtrar por rol del usuario
    final usuario = _authService.usuarioActual;
    if (usuario != null) {
      if (usuario.rol == Rol.tecnico) {
        // Los técnicos solo ven OTs asignadas a ellos
        ordenes = ordenes.where((ot) => ot.tecnicoAsignadoId == usuario.id).toList();
      } else if (usuario.rol == Rol.solicitante) {
        // Los solicitantes solo ven sus propias OTs
        ordenes = ordenes.where((ot) => ot.solicitanteId == usuario.id).toList();
      }
      // Administradores y supervisores ven todas las OTs
    }

    // Filtrar por búsqueda de texto
    if (_textoBusqueda.isNotEmpty) {
      ordenes = ordenes.where((ot) {
        final textoLower = _textoBusqueda.toLowerCase();
        return ot.idOT.toLowerCase().contains(textoLower) ||
            ot.descripcionProblema.toLowerCase().contains(textoLower) ||
            ot.ubicacion.toLowerCase().contains(textoLower) ||
            ot.solicitanteNombre.toLowerCase().contains(textoLower) ||
            (ot.tecnicoAsignadoNombre?.toLowerCase().contains(textoLower) ?? false);
      }).toList();
    }

    // Filtrar por estado seleccionado
    if (_filtroEstado != null) {
      ordenes = ordenes.where((ot) => ot.estado == _filtroEstado).toList();
    }

    // Filtrar por tipo de falla
    if (_filtroTipoFalla != null) {
      ordenes = ordenes.where((ot) => ot.tipoFalla == _filtroTipoFalla).toList();
    }

    // Filtrar por prioridad
    if (_filtroPrioridad != null) {
      ordenes = ordenes.where((ot) {
        final prioridad = ot.prioridadAsignada ?? ot.prioridadSolicitada;
        return prioridad == _filtroPrioridad;
      }).toList();
    }

    // Filtrar por técnico asignado
    if (_filtroTecnicoId != null) {
      ordenes = ordenes.where((ot) => ot.tecnicoAsignadoId == _filtroTecnicoId).toList();
    }

    // Aplicar ordenamiento
    switch (_ordenamiento) {
      case OrdenamientoOT.masReciente:
        ordenes.sort((a, b) => b.fechaSolicitud.compareTo(a.fechaSolicitud));
        break;
      case OrdenamientoOT.masAntigua:
        ordenes.sort((a, b) => a.fechaSolicitud.compareTo(b.fechaSolicitud));
        break;
      case OrdenamientoOT.prioridadAlta:
        ordenes.sort((a, b) {
          final prioridadA = a.prioridadAsignada ?? a.prioridadSolicitada;
          final prioridadB = b.prioridadAsignada ?? b.prioridadSolicitada;
          return prioridadA.index.compareTo(prioridadB.index);
        });
        break;
      case OrdenamientoOT.prioridadBaja:
        ordenes.sort((a, b) {
          final prioridadA = a.prioridadAsignada ?? a.prioridadSolicitada;
          final prioridadB = b.prioridadAsignada ?? b.prioridadSolicitada;
          return prioridadB.index.compareTo(prioridadA.index);
        });
        break;
    }

    return ordenes;
  }

  int _contarPorEstado(EstadoOT estado) {
    // Filtrar por rol del usuario
    var ordenes = _ordenesTrabajo;
    final usuario = _authService.usuarioActual;

    if (usuario != null) {
      if (usuario.rol == Rol.tecnico) {
        // Los técnicos solo cuentan OTs asignadas a ellos
        ordenes = ordenes.where((ot) => ot.tecnicoAsignadoId == usuario.id).toList();
      } else if (usuario.rol == Rol.solicitante) {
        // Los solicitantes solo cuentan sus propias OTs
        ordenes = ordenes.where((ot) => ot.solicitanteId == usuario.id).toList();
      }
      // Administradores y supervisores cuentan todas las OTs
    }

    return ordenes.where((ot) => ot.estado == estado).length;
  }

  void _agregarNuevaOT(OrdenTrabajo nuevaOT) {
    setState(() {
      _ordenesTrabajo.insert(0, nuevaOT);
    });
  }

  void _actualizarOT(OrdenTrabajo otActualizada) {
    setState(() {
      final index = _ordenesTrabajo.indexWhere((ot) => ot.idOT == otActualizada.idOT);
      if (index != -1) {
        _ordenesTrabajo[index] = otActualizada;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sistema de Mantenimiento',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (_authService.usuarioActual != null)
              Text(
                _authService.usuarioActual!.rolTexto,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          // Nombre del usuario
          if (_authService.usuarioActual != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  _authService.usuarioActual!.nombre.split(' ')[0],
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notifications_outlined, color: Colors.orange),
              ),
              onPressed: () {},
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.logout_outlined, color: Colors.red),
              ),
              onPressed: () {
                _authService.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildKPISection(),
          _buildFilterSection(),
          Expanded(
            child: _buildOTList(),
          ),
        ],
      ),
      floatingActionButton: _authService.tienePermiso(Permiso.crearOT)
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NuevaOTScreen(
                      onOTCreada: _agregarNuevaOT,
                    ),
                  ),
                );
              },
              elevation: 4,
              backgroundColor: Colors.blue[600],
              icon: const Icon(Icons.add_rounded, size: 24),
              label: const Text(
                'Nueva OT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildKPISection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[400]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.dashboard_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 135,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildKPICard(
                  'Abiertas',
                  _contarPorEstado(EstadoOT.abierta).toString(),
                  [Colors.orange[600]!, Colors.orange[400]!],
                  Icons.folder_open_rounded,
                ),
                _buildKPICard(
                  'Asignadas',
                  _contarPorEstado(EstadoOT.asignada).toString(),
                  [Colors.blue[600]!, Colors.blue[400]!],
                  Icons.assignment_ind_rounded,
                ),
                _buildKPICard(
                  'En Progreso',
                  _contarPorEstado(EstadoOT.enProgreso).toString(),
                  [Colors.purple[600]!, Colors.purple[400]!],
                  Icons.build_rounded,
                ),
                _buildKPICard(
                  'Pausadas',
                  _contarPorEstado(EstadoOT.pausada).toString(),
                  [Colors.amber[700]!, Colors.amber[400]!],
                  Icons.pause_circle_rounded,
                ),
                _buildKPICard(
                  'Pend. Cierre',
                  _contarPorEstado(EstadoOT.pendienteCierre).toString(),
                  [Colors.teal[600]!, Colors.teal[400]!],
                  Icons.pending_actions_rounded,
                ),
                _buildKPICard(
                  'Cerradas',
                  _contarPorEstado(EstadoOT.cerrada).toString(),
                  [Colors.green[600]!, Colors.green[400]!],
                  Icons.check_circle_rounded,
                ),
                _buildKPICard(
                  'Rechazadas',
                  _contarPorEstado(EstadoOT.rechazada).toString(),
                  [Colors.red[600]!, Colors.red[400]!],
                  Icons.cancel_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String label, String value, List<Color> gradientColors, IconData icon) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de búsqueda
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por ID, descripción, ubicación...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _textoBusqueda.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _textoBusqueda = '';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              setState(() {
                _textoBusqueda = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Encabezado de filtros con botón de avanzados
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.filter_list_rounded, size: 20, color: Colors.black54),
                  SizedBox(width: 8),
                  Text(
                    'Filtros',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (_filtroEstado != null || _filtroTipoFalla != null ||
                      _filtroPrioridad != null || _filtroTecnicoId != null)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _filtroEstado = null;
                          _filtroTipoFalla = null;
                          _filtroPrioridad = null;
                          _filtroTecnicoId = null;
                        });
                      },
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('Limpiar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red[600],
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _mostrarFiltrosAvanzados = !_mostrarFiltrosAvanzados;
                      });
                    },
                    icon: Icon(
                      _mostrarFiltrosAvanzados ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                    ),
                    label: Text(_mostrarFiltrosAvanzados ? 'Ocultar' : 'Avanzados'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Ordenamiento
          Row(
            children: [
              const Icon(Icons.sort, size: 20, color: Colors.black54),
              const SizedBox(width: 8),
              const Text(
                'Ordenar por:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<OrdenamientoOT>(
                  initialValue: _ordenamiento,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: OrdenamientoOT.masReciente,
                      child: Text('Más reciente', style: TextStyle(fontSize: 13)),
                    ),
                    DropdownMenuItem(
                      value: OrdenamientoOT.masAntigua,
                      child: Text('Más antigua', style: TextStyle(fontSize: 13)),
                    ),
                    DropdownMenuItem(
                      value: OrdenamientoOT.prioridadAlta,
                      child: Text('Prioridad (Alta primero)', style: TextStyle(fontSize: 13)),
                    ),
                    DropdownMenuItem(
                      value: OrdenamientoOT.prioridadBaja,
                      child: Text('Prioridad (Baja primero)', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _ordenamiento = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filtros por estado
          const Text(
            'Estado',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Todos', null),
                _buildFilterChip('Abiertas', EstadoOT.abierta),
                _buildFilterChip('Asignadas', EstadoOT.asignada),
                _buildFilterChip('En Progreso', EstadoOT.enProgreso),
                _buildFilterChip('Pausadas', EstadoOT.pausada),
                _buildFilterChip('Pend. Cierre', EstadoOT.pendienteCierre),
                _buildFilterChip('Cerradas', EstadoOT.cerrada),
                _buildFilterChip('Rechazadas', EstadoOT.rechazada),
              ],
            ),
          ),

          // Filtros avanzados
          if (_mostrarFiltrosAvanzados) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Filtro por tipo de falla
            const Text(
              'Tipo de Falla',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTipoFallaChip('Todos', null),
                  _buildTipoFallaChip('Eléctrica', TipoFalla.electrica),
                  _buildTipoFallaChip('Plomería', TipoFalla.plomeria),
                  _buildTipoFallaChip('Climatización', TipoFalla.climatizacion),
                  _buildTipoFallaChip('Estructural', TipoFalla.estructural),
                  _buildTipoFallaChip('Limpieza', TipoFalla.limpieza),
                  _buildTipoFallaChip('Seguridad', TipoFalla.seguridad),
                  _buildTipoFallaChip('Tecnología', TipoFalla.tecnologia),
                  _buildTipoFallaChip('Otro', TipoFalla.otro),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Filtro por prioridad
            const Text(
              'Prioridad',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPrioridadChip('Todas', null),
                  _buildPrioridadChip('Crítica', Prioridad.critica),
                  _buildPrioridadChip('Alta', Prioridad.alta),
                  _buildPrioridadChip('Media', Prioridad.media),
                  _buildPrioridadChip('Baja', Prioridad.baja),
                ],
              ),
            ),

            // Filtro por técnico (solo para admin y supervisor)
            if (_authService.usuarioActual != null &&
                (_authService.usuarioActual!.rol == Rol.administrador ||
                    _authService.usuarioActual!.rol == Rol.supervisor)) ...[
              const SizedBox(height: 16),
              const Text(
                'Técnico Asignado',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTecnicoChip('Todos', null),
                    ..._getTecnicos().map((tecnico) =>
                        _buildTecnicoChip(tecnico.nombre.split(' ')[0], tecnico.id)),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, EstadoOT? estado) {
    final isSelected = _filtroEstado == estado;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _filtroEstado = estado;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[400]!],
                  )
                : null,
            color: isSelected ? null : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTList() {
    if (_ordenesFiltradas.isEmpty) {
      return const Center(
        child: Text('No hay órdenes de trabajo con este filtro'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _ordenesFiltradas.length,
      itemBuilder: (context, index) {
        final ot = _ordenesFiltradas[index];
        return _buildOTCard(ot);
      },
    );
  }

  Widget _buildOTCard(OrdenTrabajo ot) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleOTScreen(
              ordenTrabajo: ot,
              onOTActualizada: _actualizarOT,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ot.idOT,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildEstadoBadge(ot.estado),
                      ],
                    ),
                  ),
                  _buildPrioridadBadge(ot.prioridadAsignada ?? ot.prioridadSolicitada),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getTipoFallaColor(ot.tipoFalla).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getTipoFallaIcon(ot.tipoFalla),
                            size: 20,
                            color: _getTipoFallaColor(ot.tipoFalla),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ot.tipoFallaTexto,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ot.descripcionProblema,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      ot.ubicacion,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 6),
                  Text(
                    ot.solicitanteNombre,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              if (ot.tecnicoAsignadoNombre != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.engineering_outlined, size: 16, color: Colors.blue[600]),
                    const SizedBox(width: 6),
                    Text(
                      ot.tecnicoAsignadoNombre!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 16, color: Colors.blue[700]),
                        const SizedBox(width: 6),
                        Text(
                          _formatFecha(ot.fechaSolicitud),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (ot.costoTotalMateriales > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '\$${ot.costoTotalMateriales.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTipoFallaColor(TipoFalla tipo) {
    switch (tipo) {
      case TipoFalla.electrica:
        return Colors.amber[700]!;
      case TipoFalla.plomeria:
        return Colors.blue[700]!;
      case TipoFalla.climatizacion:
        return Colors.cyan[700]!;
      case TipoFalla.estructural:
        return Colors.brown[700]!;
      case TipoFalla.limpieza:
        return Colors.green[700]!;
      case TipoFalla.seguridad:
        return Colors.red[700]!;
      case TipoFalla.tecnologia:
        return Colors.purple[700]!;
      case TipoFalla.otro:
        return Colors.grey[700]!;
    }
  }

  Widget _buildEstadoBadge(EstadoOT estado) {
    Color color;
    IconData icon;
    String texto;

    switch (estado) {
      case EstadoOT.abierta:
        color = Colors.orange[600]!;
        icon = Icons.folder_open_rounded;
        texto = 'Abierta';
        break;
      case EstadoOT.asignada:
        color = Colors.blue[600]!;
        icon = Icons.assignment_ind_rounded;
        texto = 'Asignada';
        break;
      case EstadoOT.enProgreso:
        color = Colors.purple[600]!;
        icon = Icons.play_circle_outline_rounded;
        texto = 'En Progreso';
        break;
      case EstadoOT.pausada:
        color = Colors.amber[700]!;
        icon = Icons.pause_circle_outline_rounded;
        texto = 'Pausada';
        break;
      case EstadoOT.pendienteCierre:
        color = Colors.teal[600]!;
        icon = Icons.pending_actions_rounded;
        texto = 'Pend. Cierre';
        break;
      case EstadoOT.cerrada:
        color = Colors.green[600]!;
        icon = Icons.check_circle_outline_rounded;
        texto = 'Cerrada';
        break;
      case EstadoOT.rechazada:
        color = Colors.red[600]!;
        icon = Icons.cancel_outlined;
        texto = 'Rechazada';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            texto,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioridadBadge(Prioridad prioridad) {
    List<Color> gradientColors;
    IconData icon;
    String texto;

    switch (prioridad) {
      case Prioridad.critica:
        gradientColors = [Colors.red[700]!, Colors.red[500]!];
        icon = Icons.warning_rounded;
        texto = 'CRÍTICA';
        break;
      case Prioridad.alta:
        gradientColors = [Colors.orange[700]!, Colors.orange[500]!];
        icon = Icons.priority_high_rounded;
        texto = 'ALTA';
        break;
      case Prioridad.media:
        gradientColors = [Colors.blue[600]!, Colors.blue[400]!];
        icon = Icons.remove_rounded;
        texto = 'MEDIA';
        break;
      case Prioridad.baja:
        gradientColors = [Colors.green[600]!, Colors.green[400]!];
        icon = Icons.arrow_downward_rounded;
        texto = 'BAJA';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTipoFallaIcon(TipoFalla tipo) {
    switch (tipo) {
      case TipoFalla.electrica:
        return Icons.electrical_services;
      case TipoFalla.plomeria:
        return Icons.plumbing;
      case TipoFalla.climatizacion:
        return Icons.ac_unit;
      case TipoFalla.estructural:
        return Icons.foundation;
      case TipoFalla.limpieza:
        return Icons.cleaning_services;
      case TipoFalla.seguridad:
        return Icons.security;
      case TipoFalla.tecnologia:
        return Icons.computer;
      case TipoFalla.otro:
        return Icons.build;
    }
  }

  String _formatFecha(DateTime fecha) {
    final diferencia = DateTime.now().difference(fecha);

    if (diferencia.inMinutes < 1) {
      return 'Hace un momento';
    } else if (diferencia.inMinutes < 60) {
      return 'Hace ${diferencia.inMinutes} min';
    } else if (diferencia.inHours < 24) {
      return 'Hace ${diferencia.inHours}h';
    } else if (diferencia.inDays < 7) {
      return 'Hace ${diferencia.inDays}d';
    } else {
      return '${fecha.day}/${fecha.month}/${fecha.year}';
    }
  }

  Widget _buildTipoFallaChip(String label, TipoFalla? tipo) {
    final isSelected = _filtroTipoFalla == tipo;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _filtroTipoFalla = tipo;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [Colors.purple[600]!, Colors.purple[400]!],
                  )
                : null,
            color: isSelected ? null : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.purple[600]! : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrioridadChip(String label, Prioridad? prioridad) {
    final isSelected = _filtroPrioridad == prioridad;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _filtroPrioridad = prioridad;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [Colors.orange[600]!, Colors.orange[400]!],
                  )
                : null,
            color: isSelected ? null : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.orange[600]! : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTecnicoChip(String label, String? tecnicoId) {
    final isSelected = _filtroTecnicoId == tecnicoId;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _filtroTecnicoId = tecnicoId;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [Colors.teal[600]!, Colors.teal[400]!],
                  )
                : null,
            color: isSelected ? null : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.teal[600]! : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.teal.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  List<Usuario> _getTecnicos() {
    return usuariosDummy.where((usuario) => usuario.rol == Rol.tecnico).toList();
  }
}
