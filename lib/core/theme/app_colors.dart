import 'package:flutter/material.dart';

class AppColors {
  // Colores principales
  static const Color primary = Color(0xFFFF7043); // Coral vibrante
  static const Color secondary = Color(0xFF1A237E); // Índigo Profundo

  // Colores de fondo y superficie
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);

  // Colores de texto
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  // Colores de estado
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);

  // Colores grises adicionales para KDS y consistencia visual (Gris/Blanco/Naranja)
  static const Color greyLight = Color(
    0xFFF8FAFC,
  ); // Fondo suave de ítems (Slate 50)
  static const Color greyBackground = Color(
    0xFFF1F5F9,
  ); // Fondo de pantalla general (Slate 100)
  static const Color greyBorder = Color(
    0xFFE2E8F0,
  ); // Bordes de tarjetas e ítems (Slate 200)
  static const Color greyMedium = Color(
    0xFF94A3B8,
  ); // Iconos e inactivos (Slate 400)
  static const Color greyText = Color(
    0xFF475569,
  ); // Texto secundario premium (Slate 600)

  // Tonos naranja corporativos suaves para estados y alertas
  static const Color orangeLight = Color(
    0xFFFFF3E0,
  ); // Fondo suave para notas/avisos
  static const Color orangeAlert = Color(
    0xFFE65100,
  ); // Texto/icono para notas de comanda

  // Colores específicos del KDS (Categorías de comida y estadísticas)
  static const Color categoryEntrada = Color(
    0xFF00ACC1,
  ); // Color para Entradas (Teal)
  static const Color categoryBebida = Color(
    0xFF7E57C2,
  ); // Color para Bebidas (Púrpura)
  static const Color statBlue = Color(
    0xFF1E88E5,
  ); // Azul brillante para indicador de Cocina

  // Degradados
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFFF8A65)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
