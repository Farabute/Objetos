object rolando {
	
	var valorBaseNivel = 3
	var property hechizoPreferido = espectroMalefico
	
	var property valorBaseLucha = 1
	var property artefactos = []
	
	method nivelDeHechiceria() = (valorBaseNivel * hechizoPreferido.poder()) + fuerzaOscura.valorFuerzaOscura()
			
	method seCreePoderoso() = hechizoPreferido.esPoderoso()
	
	method agregarArtefacto(unArtefacto){
		artefactos.add(unArtefacto)
	}
	
	method removerArtefacto(unArtefacto){
		artefactos.remove(unArtefacto)
	}
	
	method removerTodosLosArtefactos(){
		artefactos.clear()
	}
	
	method habilidadParaLucha() = valorBaseLucha + self.valorDeLuchaDeArtefactos()
	
	method valorDeLuchaDeArtefactos() = artefactos.sum({artefacto => artefacto.unidadesDeLucha()})
	
	method tieneMayorHabilidadDeLucha() = self.habilidadParaLucha() > self.nivelDeHechiceria()
	
	method estaCargado() = artefactos.size() >= 5

}

object fuerzaOscura{
	var property valorFuerzaOscura = 5
	
	method eclipse() {
		valorFuerzaOscura =  valorFuerzaOscura*2
	}
	
}


/** Hechizos */

object espectroMalefico{
	var property nombre = "Espectro maléfico"
	
	method poder() = nombre.length()
	
	method unidadesRefuerzo() = self.poder()
	
	method esPoderoso() = self.poder() > 15
}

object hechizoBasico{

	method poder() = 10
	
	method unidadesRefuerzo() = self.poder()

	method esPoderoso() = false
}

object libroDeHechizos{
	var property hechizos = []
	
	method agregarHechizo(unHechizo){
		hechizos.add(unHechizo)
	}
	
	method removerHechizo(unHechizo){
		hechizos.remove(unHechizo)
	}
	
	method hechizosPoderosos() = hechizos.filter({hechizo => hechizo.esPoderoso()})
	
	method poder() = (self.hechizosPoderosos()).sum({hechizo => hechizo.poder()})
	
}

/**  ¿Qué sucede si el libro de hechizos incluye como hechizo al mismo libro de hechizos?

En principio, se podría agregar sin problema, pero cuando se le pida evaluar el nivel de hechicería,
se genera un ciclo infinito, que nunca cortaría de evaluar hasta que se le acabe la memoria.

*/

/** Artefactos */


object espadaDelDestino{
	method unidadesDeLucha() = 3
}

object collarDivino{
	var property perlas = 0
	
	method unidadesDeLucha() = self.perlas()
}

object mascaraOscura {
	method unidadesDeLucha() = 4.max(fuerzaOscura.valorFuerzaOscura() / 2)	
}

object armadura{
	var unidadesBaseDeLucha = 2
	var property refuerzo = ninguno
		
	method unidadesDeLucha() = unidadesBaseDeLucha + refuerzo.unidadesRefuerzo()
}

object espejoFantastico{
	var unidadesDeLucha = 0
	var portador
	var artefactosLuchador = []
	
	method portador(unLuchador){
		portador = unLuchador
	}
	
	method unidadesDeLucha(){
		artefactosLuchador = portador.artefactos()
		artefactosLuchador.remove(self)
		if (!(artefactosLuchador.isEmpty())){
			unidadesDeLucha = artefactosLuchador.map({artefacto => artefacto.unidadesDeLucha()}).max()
		}
		return unidadesDeLucha
	}
}



/* Refuerzos Armadura*/

object cotaDeMalla{	
	method unidadesRefuerzo() = 1
}


object bendicion{
	var property luchador = rolando
	
	method unidadesRefuerzo() = luchador.nivelDeHechiceria()
}

object ninguno{
	method unidadesRefuerzo() = 0
}
