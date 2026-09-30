// src/services/puntaje.service.js
function calcularPuntaje({ experienciaCandidato, experienciaMinima, cartaPresentacion, fuente }) {
    let puntaje = 0;
  
    // Experiencia (máx. 60)
    if (experienciaCandidato >= experienciaMinima) {
      const extra = experienciaCandidato - experienciaMinima;
      puntaje += 40 + Math.min(extra * 5, 20);
    } else if (experienciaMinima > 0) {
      puntaje += Math.round(40 * (experienciaCandidato / experienciaMinima));
    }
  
    // Carta de presentación (máx. 15)
    const len = cartaPresentacion.trim().length;
    if (len >= 200) puntaje += 15;
    else if (len >= 50) puntaje += 8;
  
    // Fuente (máx. 25)
    const bonoFuente = { REFERIDO: 25, LINKEDIN: 15, PORTAL: 10, OTRO: 5 };
    puntaje += bonoFuente[fuente] ?? 0;
  
    return Math.min(puntaje, 100);
  }
  
  module.exports = { calcularPuntaje };