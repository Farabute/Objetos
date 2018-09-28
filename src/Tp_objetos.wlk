object rolando {

	var property valorBaseNivel = 3
	var property hechizoPreferido = espectroMalefico
	
	var property valorBaseLucha = 1
	var property artefactos = []
	
	method nivelDeHechiceria() = (self.valorBaseNivel() * hechizoPreferido.poder()) + fuerzaOscura.valorFuerzaOscura()
			
	method seCreePoderoso() = self.hechizoPreferido().esPoderoso()
	
	method agregarArtefacto(unArtefacto){
		self.artefactos().add(unArtefacto)
	}
	
	method removerArtefacto(unArtefacto){
		self.artefactos().remove(unArtefacto)
	}
	
	method removerTodosLosArtefactos(){
		self.artefactos().clear()
	}
	
	method artefactosVinculados() = self.artefactos().filter({artefacto => artefacto.estaVinculado()})
	
	method artefactosSinVinculo() = self.artefactos().filter({artefacto => !(artefacto.estaVinculado())})
	
	
	method habilidadParaLucha() = self.valorBaseLucha() + self.valorDeLuchaDeArtefactos()
	
	method valorDeLuchaDeArtefactos() = self.artefactosVinculados().sum({artefacto => artefacto.unidadesDeLucha(self)}) + self.artefactosSinVinculo().sum({artefacto => artefacto.unidadesDeLucha()})
	
	method tieneMayorHabilidadDeLucha() = self.habilidadParaLucha() > self.nivelDeHechiceria()
	
	method estaCargado() = self.artefactos().size() >= 5

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
	
	method poder() = self.nombre().length()
	
	method unidadesRefuerzo() = self.poder()
	
	method esPoderoso() = self.poder() > 15
	
	method estaVinculado() = false
}

object hechizoBasico{

	method poder() = 10
	
	method unidadesRefuerzo() = self.poder()

	method esPoderoso() = false
	
	method estaVinculado() = false
}

object libroDeHechizos{
	var property hechizos = []
	
	method hechizosValidos() = self.hechizos().filter({hechizo => !(hechizo == self)})
	
	method agregarHechizo(unHechizo){
		self.hechizos().add(unHechizo)
	}
	
	method removerHechizo(unHechizo){
		self.hechizos().remove(unHechizo)
	}
	
	method hechizosPoderosos() = self.hechizosValidos().filter({hechizo => hechizo.esPoderoso()})
	
	method poder() = (self.hechizosPoderosos()).sum({hechizo => hechizo.poder()})
	
}

/**  ¿Qué sucede si el libro de hechizos incluye como hechizo al mismo libro de hechizos?

En principio, se podría agregar sin problema, pero cuando se le pida evaluar el nivel de hechicería,
se genera un ciclo infinito, que nunca cortaría de evaluar hasta que se le acabe la memoria.

*/

/** Artefactos */


object espadaDelDestino{
	method unidadesDeLucha() = 3
	method estaVinculado() = false
}

object collarDivino{
	var property perlas = 0
	
	method unidadesDeLucha() = self.perlas()
	
	method estaVinculado() = false
}

object mascaraOscura {
	method unidadesDeLucha() = 4.max(fuerzaOscura.valorFuerzaOscura() / 2)
	method estaVinculado() = false	
}

object armadura{
	var property unidadesBaseDeLucha = 2
	var property refuerzo = ninguno
	
	method unidadesDeLuchadelRefuerzo(portador) = if(self.refuerzo().estaVinculado()){return self.refuerzo().unidadesRefuerzo(portador)}else{return self.refuerzo().unidadesRefuerzo()}
		
	method unidadesDeLucha(portador) = self.unidadesBaseDeLucha() + self.unidadesDeLuchadelRefuerzo(portador)
	
	method estaVinculado() = true
}

object espejoFantastico{
	var unidadesDeLucha = 0
	var property artefactosLuchador = []
	
	method estaVinculado() = true
	
	method artefactosVinculados() = self.artefactosLuchador().filter({artefacto => artefacto.estaVinculado()})
	
	method artefactosSinVinculo() = self.artefactosLuchador().filter({artefacto => !(artefacto.estaVinculado())})
	
	method unidadesDeLuchaDeTodosLosArtefactos(portador) = (self.artefactosVinculados().map({artefacto => artefacto.unidadesDeLucha(portador)}))+(self.artefactosSinVinculo().map({artefacto => artefacto.unidadesDeLucha()}))
	
	method unidadesDeLucha(portador){
		artefactosLuchador = portador.artefactos()
		artefactosLuchador.remove(self)
		if (!(artefactosLuchador.isEmpty())){
			unidadesDeLucha = self.unidadesDeLuchaDeTodosLosArtefactos(portador).max()
		}
		return unidadesDeLucha
	}
}



/* Refuerzos Armadura*/

object cotaDeMalla{	
	method estaVinculado() = false
	method unidadesRefuerzo() = 1
}


object bendicion{
	method estaVinculado() = true
	method unidadesRefuerzo(luchador) = luchador.nivelDeHechiceria()
}

object ninguno{
	method estaVinculado() = false
	method unidadesRefuerzo() = 0
}
