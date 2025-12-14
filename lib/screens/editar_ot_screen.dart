import 'package:flutter/material.dart';
import '../models/orden_trabajo.dart' as models;
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../data/usuarios_dummy.dart';

class EditarOTScreen extends StatefulWidget {
  final models.OrdenTrabajo ordenTrabajo;
  final Function(models.OrdenTrabajo) onGuardar;

  const EditarOTScreen({
    super.key,
    required this.ordenTrabajo,
    required this.onGuardar,
  });

  @override
  State<EditarOTScreen> createState() => _EditarOTScreenState();
}

class _EditarOTScreenState extends State<EditarOTScreen> with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  late TabController _tabController;

  late models.EstadoOT _estadoSeleccionado;
  late models.Prioridad _prioridadSeleccionada;
  late String _descripcion;
  String? _tecnicoSeleccionadoId;
  String? _descripcionTrabajo;
  final List<models.Material> _materialesAgregados = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _estadoSeleccionado = widget.ordenTrabajo.estado;
    _prioridadSeleccionada = widget.ordenTrabajo.prioridadAsignada ?? widget.ordenTrabajo.prioridadSolicitada;
    _descripcion = widget.ordenTrabajo.descripcionProblema;
    _tecnicoSeleccionadoId = widget.ordenTrabajo.tecnicoAsignadoId;
    _descripcionTrabajo = widget.ordenTrabajo.descripcionTrabajoRealizado;
    _materialesAgregados.addAll(widget.ordenTrabajo.materialesUsados);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            Text(
              'Gestionar OT',
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.ordenTrabajo.idOT,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue[700],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.blue[700],
          tabs: const [
            Tab(text: 'General', icon: Icon(Icons.edit_rounded, size: 20)),
            Tab(text: 'Asignación', icon: Icon(Icons.assignment_ind_rounded, size: 20)),
            Tab(text: 'Trabajo', icon: Icon(Icons.build_rounded, size: 20)),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: _guardarCambios,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Guardar'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue[700],
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGeneralTab(),
          _buildAsignacionTab(),
          _buildTrabajoTab(),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Estado de la OT'),
          const SizedBox(height: 12),
          _buildEstadoSelector(),

          const SizedBox(height: 24),
          _buildSectionTitle('Prioridad'),
          const SizedBox(height: 12),
          _buildPrioridadSelector(),

          const SizedBox(height: 24),
          _buildSectionTitle('Descripción del Problema'),
          const SizedBox(height: 12),
          TextField(
            controller: TextEditingController(text: _descripcion),
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Descripción...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) => _descripcion = value,
          ),
        ],
      ),
    );
  }

  Widget _buildAsignacionTab() {
    final tecnicos = usuariosDummy.where((u) => u.rol == Rol.tecnico).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Asignar Técnico'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: tecnicos.map((tecnico) {
                final isSelected = _tecnicoSeleccionadoId == tecnico.id;
                return ListTile(
                  selected: isSelected,
                  selectedTileColor: Colors.blue[50],
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? Colors.blue[700] : Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                  ),
                  title: Text(
                    tecnico.nombre,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(tecnico.email),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: Colors.blue[700])
                      : null,
                  onTap: () {
                    setState(() {
                      _tecnicoSeleccionadoId = tecnico.id;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrabajoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Descripción del Trabajo Realizado'),
          const SizedBox(height: 12),
          TextField(
            controller: TextEditingController(text: _descripcionTrabajo),
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Describe el trabajo realizado...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) => _descripcionTrabajo = value,
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('Materiales Utilizados'),
              ElevatedButton.icon(
                onPressed: _agregarMaterial,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Agregar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_materialesAgregados.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'No hay materiales agregados',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._materialesAgregados.map((material) => _buildMaterialCard(material)),
        ],
      ),
    );
  }

  Widget _buildEstadoSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: models.EstadoOT.values.map((estado) {
        final isSelected = _estadoSeleccionado == estado;
        final color = _getEstadoColor(estado);

        return InkWell(
          onTap: () => setState(() => _estadoSeleccionado = estado),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.15) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getEstadoIcon(estado),
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _getEstadoTexto(estado),
                  style: TextStyle(
                    color: isSelected ? color : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrioridadSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: models.Prioridad.values.map((prioridad) {
        final isSelected = _prioridadSeleccionada == prioridad;
        final color = _getPrioridadColor(prioridad);

        return InkWell(
          onTap: () => setState(() => _prioridadSeleccionada = prioridad),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(colors: [color, color.withValues(alpha: 0.7)])
                  : null,
              color: isSelected ? null : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getPrioridadIcon(prioridad),
                  color: isSelected ? Colors.white : color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _getPrioridadTexto(prioridad),
                  style: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMaterialCard(models.Material material) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.inventory_2, color: Colors.blue[700], size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Cantidad: ${material.cantidad} - \$${material.costoUnitario} c/u',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${material.costoTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: Colors.red[400],
                onPressed: () {
                  setState(() {
                    _materialesAgregados.remove(material);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  void _agregarMaterial() {
    showDialog(
      context: context,
      builder: (context) => _AgregarMaterialDialog(
        onAgregar: (material) {
          setState(() {
            _materialesAgregados.add(material);
          });
        },
      ),
    );
  }

  void _guardarCambios() {
    final tecnicoSeleccionado = _tecnicoSeleccionadoId != null
        ? usuariosDummy.firstWhere((u) => u.id == _tecnicoSeleccionadoId)
        : null;

    final otActualizada = widget.ordenTrabajo.copyWith(
      estado: _estadoSeleccionado,
      prioridadAsignada: _prioridadSeleccionada,
      descripcionProblema: _descripcion,
      tecnicoAsignadoId: tecnicoSeleccionado?.id,
      tecnicoAsignadoNombre: tecnicoSeleccionado?.nombre,
      fechaAsignacion: tecnicoSeleccionado != null && widget.ordenTrabajo.tecnicoAsignadoId == null
          ? DateTime.now()
          : widget.ordenTrabajo.fechaAsignacion,
      descripcionTrabajoRealizado: _descripcionTrabajo,
      materialesUsados: _materialesAgregados,
    );

    widget.onGuardar(otActualizada);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Cambios guardados exitosamente'),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Color _getEstadoColor(models.EstadoOT estado) {
    switch (estado) {
      case models.EstadoOT.abierta: return Colors.orange[600]!;
      case models.EstadoOT.asignada: return Colors.blue[600]!;
      case models.EstadoOT.enProgreso: return Colors.purple[600]!;
      case models.EstadoOT.pausada: return Colors.amber[700]!;
      case models.EstadoOT.pendienteCierre: return Colors.teal[600]!;
      case models.EstadoOT.cerrada: return Colors.green[600]!;
      case models.EstadoOT.rechazada: return Colors.red[600]!;
    }
  }

  IconData _getEstadoIcon(models.EstadoOT estado) {
    switch (estado) {
      case models.EstadoOT.abierta: return Icons.folder_open_rounded;
      case models.EstadoOT.asignada: return Icons.assignment_ind_rounded;
      case models.EstadoOT.enProgreso: return Icons.play_circle_rounded;
      case models.EstadoOT.pausada: return Icons.pause_circle_rounded;
      case models.EstadoOT.pendienteCierre: return Icons.pending_actions_rounded;
      case models.EstadoOT.cerrada: return Icons.check_circle_rounded;
      case models.EstadoOT.rechazada: return Icons.cancel_rounded;
    }
  }

  String _getEstadoTexto(models.EstadoOT estado) {
    switch (estado) {
      case models.EstadoOT.abierta: return 'Abierta';
      case models.EstadoOT.asignada: return 'Asignada';
      case models.EstadoOT.enProgreso: return 'En Progreso';
      case models.EstadoOT.pausada: return 'Pausada';
      case models.EstadoOT.pendienteCierre: return 'Pend. Cierre';
      case models.EstadoOT.cerrada: return 'Cerrada';
      case models.EstadoOT.rechazada: return 'Rechazada';
    }
  }

  Color _getPrioridadColor(models.Prioridad prioridad) {
    switch (prioridad) {
      case models.Prioridad.critica: return Colors.red[700]!;
      case models.Prioridad.alta: return Colors.orange[700]!;
      case models.Prioridad.media: return Colors.blue[600]!;
      case models.Prioridad.baja: return Colors.green[600]!;
    }
  }

  IconData _getPrioridadIcon(models.Prioridad prioridad) {
    switch (prioridad) {
      case models.Prioridad.critica: return Icons.warning_rounded;
      case models.Prioridad.alta: return Icons.priority_high_rounded;
      case models.Prioridad.media: return Icons.remove_rounded;
      case models.Prioridad.baja: return Icons.arrow_downward_rounded;
    }
  }

  String _getPrioridadTexto(models.Prioridad prioridad) {
    switch (prioridad) {
      case models.Prioridad.critica: return 'Crítica';
      case models.Prioridad.alta: return 'Alta';
      case models.Prioridad.media: return 'Media';
      case models.Prioridad.baja: return 'Baja';
    }
  }
}

class _AgregarMaterialDialog extends StatefulWidget {
  final Function(models.Material) onAgregar;

  const _AgregarMaterialDialog({required this.onAgregar});

  @override
  State<_AgregarMaterialDialog> createState() => _AgregarMaterialDialogState();
}

class _AgregarMaterialDialogState extends State<_AgregarMaterialDialog> {
  final _nombreController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _costoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Agregar Material'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nombreController,
            decoration: const InputDecoration(
              labelText: 'Nombre del material',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cantidadController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cantidad',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _costoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Costo unitario',
              prefixText: '\$',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nombreController.text.isNotEmpty &&
                _cantidadController.text.isNotEmpty &&
                _costoController.text.isNotEmpty) {
              final material = models.Material(
                id: 'MAT-${DateTime.now().millisecondsSinceEpoch}',
                nombre: _nombreController.text,
                cantidad: int.parse(_cantidadController.text),
                costoUnitario: double.parse(_costoController.text),
              );
              widget.onAgregar(material);
              Navigator.pop(context);
            }
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
