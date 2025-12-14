import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/orden_trabajo.dart';

class NuevaOTScreen extends StatefulWidget {
  final Function(OrdenTrabajo) onOTCreada;

  const NuevaOTScreen({super.key, required this.onOTCreada});

  @override
  State<NuevaOTScreen> createState() => _NuevaOTScreenState();
}

class _NuevaOTScreenState extends State<NuevaOTScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _ubicacionController = TextEditingController();

  TipoFalla _tipoFallaSeleccionado = TipoFalla.electrica;
  Prioridad _prioridadSeleccionada = Prioridad.media;
  final List<String> _archivosAdjuntos = [];
  double? _latitud;
  double? _longitud;
  bool _obteniendoUbicacion = false;

  @override
  void dispose() {
    _descripcionController.dispose();
    _ubicacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Orden de Trabajo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Información de la Solicitud',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Tipo de Falla
            const Text(
              'Tipo de Falla',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<TipoFalla>(
              initialValue: _tipoFallaSeleccionado,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(_getTipoFallaIcon(_tipoFallaSeleccionado)),
              ),
              items: TipoFalla.values.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Row(
                    children: [
                      Icon(_getTipoFallaIcon(tipo), size: 20),
                      const SizedBox(width: 8),
                      Text(_getTipoFallaTexto(tipo)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _tipoFallaSeleccionado = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Prioridad
            const Text(
              'Prioridad Solicitada',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Prioridad>(
              initialValue: _prioridadSeleccionada,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(_getPrioridadIcon(_prioridadSeleccionada)),
              ),
              items: Prioridad.values.map((prioridad) {
                return DropdownMenuItem(
                  value: prioridad,
                  child: Row(
                    children: [
                      Icon(
                        _getPrioridadIcon(prioridad),
                        size: 20,
                        color: _getPrioridadColor(prioridad),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getPrioridadTexto(prioridad),
                        style: TextStyle(
                          color: _getPrioridadColor(prioridad),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _prioridadSeleccionada = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Ubicación
            const Text(
              'Ubicación',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _ubicacionController,
              decoration: InputDecoration(
                hintText: 'Ej: Edificio A - Piso 3 - Oficina 305',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: _obteniendoUbicacion
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          _latitud != null ? Icons.my_location : Icons.location_searching,
                          color: _latitud != null ? Colors.green : null,
                        ),
                        onPressed: _obtenerUbicacion,
                        tooltip: 'Obtener ubicación GPS',
                      ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la ubicación';
                }
                return null;
              },
            ),

            // Mapa de vista previa cuando se obtiene GPS
            if (_latitud != null && _longitud != null) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_latitud!, _longitud!),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('ubicacion_nueva_ot'),
                        position: LatLng(_latitud!, _longitud!),
                        infoWindow: const InfoWindow(
                          title: 'Ubicación seleccionada',
                        ),
                      ),
                    },
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Descripción del Problema
            const Text(
              'Descripción del Problema',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descripcionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describa detalladamente el problema...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor describa el problema';
                }
                if (value.length < 10) {
                  return 'La descripción debe tener al menos 10 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Archivos Adjuntos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Archivos Adjuntos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_archivosAdjuntos.length}/5',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (_archivosAdjuntos.length < 5) {
                        setState(() {
                          _archivosAdjuntos.add('foto_${_archivosAdjuntos.length + 1}.jpg');
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Foto agregada (simulado)'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Máximo 5 archivos permitidos'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.add_a_photo, size: 20),
                    label: const Text('Foto'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (_archivosAdjuntos.length < 5) {
                        setState(() {
                          _archivosAdjuntos.add('documento_${_archivosAdjuntos.length + 1}.pdf');
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Documento agregado (simulado)'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Máximo 5 archivos permitidos'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.attach_file, size: 20),
                    label: const Text('Archivo'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_archivosAdjuntos.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: _archivosAdjuntos.asMap().entries.map((entry) {
                    final index = entry.key;
                    final archivo = entry.value;
                    final isPhoto = archivo.endsWith('.jpg') || archivo.endsWith('.png');
                    return Padding(
                      padding: EdgeInsets.only(bottom: index == _archivosAdjuntos.length - 1 ? 0 : 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isPhoto ? Icons.image : Icons.picture_as_pdf,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  archivo,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${(index + 1) * 1.2} MB',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () {
                              setState(() {
                                _archivosAdjuntos.removeAt(index);
                              });
                            },
                            color: Colors.red.shade400,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            const SizedBox(height: 30),

            // Botón de Enviar
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _crearOrdenTrabajo();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send),
                  SizedBox(width: 8),
                  Text(
                    'Enviar Solicitud',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _crearOrdenTrabajo() {
    // Generar ID único
    final numeroOT = DateTime.now().millisecondsSinceEpoch % 10000;
    final idOT = 'OT-2025-${numeroOT.toString().padLeft(4, '0')}';

    // Crear la nueva orden de trabajo
    final nuevaOT = OrdenTrabajo(
      idOT: idOT,
      fechaSolicitud: DateTime.now(),
      solicitanteId: 'SOL-${DateTime.now().millisecondsSinceEpoch % 100}',
      solicitanteNombre: 'Usuario Demo',
      ubicacion: _ubicacionController.text,
      latitud: _latitud,
      longitud: _longitud,
      tipoFalla: _tipoFallaSeleccionado,
      prioridadSolicitada: _prioridadSeleccionada,
      descripcionProblema: _descripcionController.text,
      archivosAdjuntos: List.from(_archivosAdjuntos),
      estado: EstadoOT.abierta,
    );

    // Agregar la nueva OT a la lista
    widget.onOTCreada(nuevaOT);

    // Mostrar diálogo de confirmación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600, size: 28),
            const SizedBox(width: 12),
            const Text('Solicitud Creada'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Su orden de trabajo ha sido creada exitosamente.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Número de OT:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    idOT,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Recibirá una notificación cuando un técnico sea asignado.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Aceptar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _obtenerUbicacion() async {
    setState(() {
      _obteniendoUbicacion = true;
    });

    try {
      // Verificar si el servicio de ubicación está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('El servicio de ubicación está desactivado'),
                  ),
                ],
              ),
              backgroundColor: Colors.orange[700],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
        return;
      }

      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text('Permiso de ubicación denegado'),
                    ),
                  ],
                ),
                backgroundColor: Colors.red[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Permisos de ubicación denegados permanentemente. Actívalos en la configuración.'),
                  ),
                ],
              ),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      // Obtener ubicación
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _latitud = position.latitude;
        _longitud = position.longitude;

        // Auto-llenar el campo de ubicación con las coordenadas
        final coords = 'GPS: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
        _ubicacionController.text = coords;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Ubicación GPS obtenida correctamente'),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Error al obtener ubicación: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _obteniendoUbicacion = false;
        });
      }
    }
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

  String _getTipoFallaTexto(TipoFalla tipo) {
    switch (tipo) {
      case TipoFalla.electrica:
        return 'Eléctrica';
      case TipoFalla.plomeria:
        return 'Plomería';
      case TipoFalla.climatizacion:
        return 'Climatización';
      case TipoFalla.estructural:
        return 'Estructural';
      case TipoFalla.limpieza:
        return 'Limpieza';
      case TipoFalla.seguridad:
        return 'Seguridad';
      case TipoFalla.tecnologia:
        return 'Tecnología';
      case TipoFalla.otro:
        return 'Otro';
    }
  }

  IconData _getPrioridadIcon(Prioridad prioridad) {
    switch (prioridad) {
      case Prioridad.critica:
        return Icons.warning;
      case Prioridad.alta:
        return Icons.priority_high;
      case Prioridad.media:
        return Icons.remove;
      case Prioridad.baja:
        return Icons.arrow_downward;
    }
  }

  Color _getPrioridadColor(Prioridad prioridad) {
    switch (prioridad) {
      case Prioridad.critica:
        return Colors.red;
      case Prioridad.alta:
        return Colors.orange;
      case Prioridad.media:
        return Colors.blue;
      case Prioridad.baja:
        return Colors.green;
    }
  }

  String _getPrioridadTexto(Prioridad prioridad) {
    switch (prioridad) {
      case Prioridad.critica:
        return 'Crítica';
      case Prioridad.alta:
        return 'Alta';
      case Prioridad.media:
        return 'Media';
      case Prioridad.baja:
        return 'Baja';
    }
  }
}
