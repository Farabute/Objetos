object rolando {
	
	var valorBaseNivel = 3
	var fuerzaOscura = 5
	var hechizoPreferido = espectroMalefico
	var nivelDeHechiceria
	
	var valorBaseLucha = 1
	const artefactos = [espadaDelDestino, collarDivino, mascaraOscura]
	
	var habilidadParaLucha
	
	method nivelDeHechiceria(){
		nivelDeHechiceria = (valorBaseNivel * hechizoPreferido.poder()) + fuerzaOscura
		return nivelDeHechiceria
	}
	
	method cambiarHechizoPreferido(unHechizo){
		hechizoPreferido = unHechizo	
	}
	
	method eclipse() {
		fuerzaOscura = fuerzaOscura * 2
	}
		
	method seCreePoderoso() = hechizoPreferido.esPoderoso()
	
	method fuerzaOscura() = fuerzaOscura
	
	method artefactos() = artefactos
	
	method cambiarValorBaseLucha(unValor){
		valorBaseLucha = unValor	
	}
	
	method nuevosArtefactos(nuevosArtefactos){
		artefactos.clear()
		artefactos.addAll(nuevosArtefactos)
	}
	
	method agregarArtefacto(unArtefacto){
		artefactos.add(unArtefacto)
	}
	
	method removerArtefacto(unArtefacto){
		artefactos.remove(unArtefacto)
	}
	
	method habilidadParaLucha(){
		habilidadParaLucha = valorBaseLucha + self.valorDeLuchaDeArtefactos()
		return habilidadParaLucha 
	}
	
	method valorDeLuchaDeArtefactos() = artefactos.sum({artefacto => artefacto.unidadesDeLucha()})
	
	method tieneMayorHabilidadDeLucha() = self.habilidadParaLucha() > self.nivelDeHechiceria()
	
	method estaCargado() = artefactos.size() >= 5

}


/** Hechizos */

object espectroMalefico{
	var nombre = "Espectro maléfico"
	
	method poder() = nombre.length()
	
	method cambiarNombre(unNombre){
		nombre = unNombre
	}
	
	method esPoderoso() = self.poder() > 15
}

object hechizoBasico{
	var poder = 10
	
	method poder() = poder

	method esPoderoso() = false
}

object libroDeHechizos{
	const hechizos = []
	var poder

	method nuevosHechizos(nuevosHechizos){
		hechizos.clear()
		hechizos.addAll(nuevosHechizos)
	}
	
	method agregarHechizo(unHechizo){
		hechizos.add(unHechizo)
	}
	
	method removerHechizo(unHechizo){
		hechizos.remove(unHechizo)
	}
	
	method poder(){
		poder = hechizos.filter({hechizo => hechizo.esPoderoso()}).sum({hechizo => hechizo.poder()})
		return poder
	}
}

/**  ¿Qué sucede si el libro de hechizos incluye como hechizo al mismo libro de hechizos?

En principio, se podria agregar sin problema, pero cuando se le pida evaluar el nivel de hechiceria,
se genera un ciclo infinito, que nunca cortaria de evaluar hasta que se le acabe la memoria.

*/

/** Artefactos */


object espadaDelDestino{
	var unidadesDeLucha = 3
	
	method unidadesDeLucha() = unidadesDeLucha
}

object collarDivino{
	var perlas = 5
	
	method perlas(cantidadDePerlas){
		perlas = cantidadDePerlas
	}
	
	method unidadesDeLucha() = perlas
}


object mascaraOscura{
	var unidadesDeLucha
	var luchador = rolando
	
	method agregarLuchador(unLuchador){
		luchador = unLuchador
	}
	
	method unidadesDeLucha() {
		if (luchador.fuerzaOscura() < 8){
			unidadesDeLucha = 4
		} else {
			unidadesDeLucha = luchador.fuerzaOscura() / 2 
		}
		return unidadesDeLucha
	}
}

object armadura{
	var unidadesBaseDeLucha = 2
	var refuerzo = ninguno
	var unidadesDeLucha
	
	method refuerzo(unRefuerzo){
		refuerzo = unRefuerzo
	}
	
	method unidadesDeLucha() {
		unidadesDeLucha = unidadesBaseDeLucha + refuerzo.unidadesRefuerzo()
		return unidadesDeLucha
	}
}

object espejoFantastico{
	var unidadesDeLucha = 0
	var luchador = rolando
	var artefactosLuchador = []
	
	method agregarLuchador(unLuchador){
		luchador = unLuchador
	}
	
	method unidadesDeLucha(){
		artefactosLuchador = luchador.artefactos()
		artefactosLuchador.remove(self)
		if (!(artefactosLuchador.isEmpty())){
			unidadesDeLucha = artefactosLuchador.map({artefacto => artefacto.unidadesDeLucha()}).max()
		} 
		return unidadesDeLucha
	}
}



/* Refuerzos Armadura*/

object cotaDeMalla{
	var unidadesRefuerzo = 1
	
	method unidadesRefuerzo() = unidadesRefuerzo
}


object bendicion{
	var luchador = rolando
	var unidadesRefuerzo
	
	method agregarLuchador(unLuchador){
		luchador = unLuchador
	}
	
	method luchador() = luchador
	
	method unidadesRefuerzo(){
		unidadesRefuerzo = luchador.nivelDeHechiceria()
		return unidadesRefuerzo
	}
}

object hechizo{
	var hechizo
	var unidadesRefuerzo
	
	method agregarHechizo(unHechizo){
		hechizo = unHechizo
	}
	
	method unidadesRefuerzo(){
		unidadesRefuerzo = hechizo.poder()
		return unidadesRefuerzo
	}
	
}

object ninguno{
	method unidadesRefuerzo() = 0
}


