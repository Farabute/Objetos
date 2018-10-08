class Personaje{

	var property hechizoPreferido	
	var property valorBaseLucha = 1
	var property artefactos = []
	var property monedas = 100
	
	method valorBaseNivel() = 3
	
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

	method canjeaHechizo(unHechizo) {
		if (monedas >= self.costoHechizo(unHechizo)) {
			monedas -= self.costoHechizo(unHechizo)
			hechizoPreferido = unHechizo
		}
	}
	
	method costoHechizo(unHechizo) = 0.max(unHechizo.precio() - self.hechizoPreferido().precio() / 2)

}

object fuerzaOscura{
	var property valorFuerzaOscura = 5
	
	method eclipse() {
		valorFuerzaOscura =  valorFuerzaOscura*2
	}
	
}


/** Hechizos */
class Logos{
	var property nombre
	
	var property valorMultiplicador
	
	method poder() = valorMultiplicador * self.nombre().length()
	
	method unidadesRefuerzo() = self.poder()
	
	method esPoderoso() = self.poder() > 15
	
	method estaVinculado() = false
	
	method claseHechizo() = true
	
	method precio() = self.poder()
}


object hechizoBasico{

	method poder() = 10
	
	method unidadesRefuerzo() = self.poder()

	method esPoderoso() = false
	
	method estaVinculado() = false
	
	method claseHechizo() = true
	
	method precio() = self.poder()
}

class LibroDeHechizos{
	var property hechizos = []
	
	method hechizosValidos() = self.hechizos().filter({hechizo => hechizo.claseHechizo()})
	
	method agregarHechizo(unHechizo){
		self.hechizos().add(unHechizo)
	}
	
	method agregarHechizos(unHechizo){
		self.hechizos().addAll(unHechizo)
	}
	
	method removerHechizo(unHechizo){
		self.hechizos().remove(unHechizo)
	}
	
	method hechizosPoderosos() = self.hechizosValidos().filter({hechizo => hechizo.esPoderoso()})
	
	method poder() = (self.hechizosPoderosos()).sum({hechizo => hechizo.poder()})
	
	method claseHechizo() = false
	
}

/** Artefactos */

class Arma{
	method unidadesDeLucha() = 3
	method estaVinculado() = false
	method precio() = 5 * self.unidadesDeLucha()
}


object collarDivino{
	var property perlas = 0
	
	method unidadesDeLucha() = self.perlas()
	
	method estaVinculado() = false
	
	method precio() = 2 * self.perlas()
}

class MascaraOscura {
	var property indiceDeOscuridad
	var property valorMinimo = 4
	method unidadesDeLucha() = valorMinimo.max(fuerzaOscura.valorFuerzaOscura() * self.indiceDeOscuridad() / 2)
	method estaVinculado() = false	
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
	
	method precio() = 90
}


class Armadura{
	var property unidadesBaseDeLucha
	var property refuerzo = ninguno
	
	method unidadesDeLuchadelRefuerzo(portador) = if(self.refuerzo().estaVinculado()){return self.refuerzo().unidadesRefuerzo(portador)}else{return self.refuerzo().unidadesRefuerzo()}
		
	method unidadesDeLucha(portador) = self.unidadesBaseDeLucha() + self.unidadesDeLuchadelRefuerzo(portador)
	
	method estaVinculado() = true
}


/* Refuerzos Armadura*/

class CotaDeMalla{	
	var property unidadesRefuerzo
	method estaVinculado() = false
}


object bendicion{
	method estaVinculado() = true
	method unidadesRefuerzo(luchador) = luchador.nivelDeHechiceria()
}

object ninguno{
	method estaVinculado() = false
	method unidadesRefuerzo() = 0
}
