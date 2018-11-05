class Personaje{

	var property hechizoPreferido	
	var property valorBaseLucha = 1
	var property artefactos = []
	var property monedas = 100
	const property pesoMaximo = 200
	
	method valorBaseNivel() = 3
	
	method nivelDeHechiceria() = (self.valorBaseNivel() * self.hechizoPreferido().poder()) + fuerzaOscura.valorFuerzaOscura()
			
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
		if (self.monedas() >= self.costoHechizo(unHechizo)) {
			self.monedas(self.monedas() - self.costoHechizo(unHechizo))
			self.hechizoPreferido(unHechizo)
		}
	}
	
	method costoHechizo(unHechizo) = 0.max(unHechizo.precio() - self.hechizoPreferido().precio() / 2)
	
	method restarNMonedas(unNumero){
		self.monedas(self.monedas() - unNumero)
	}
	
	method podesCostear(unArtefacto) = self.monedas() >= unArtefacto.precio()
	
	
	method compraArtefacto(unArtefacto) {
		if (self.podesCostear(unArtefacto)) {
			self.restarNMonedas(unArtefacto.precio())
			self.agregarArtefacto(unArtefacto)
		}
	}

}

object fuerzaOscura{
	var property valorFuerzaOscura = 5
	
	method eclipse() {
		self.valorFuerzaOscura(self.valorFuerzaOscura() * 2)
	}
	
}

class NPC inherits Personaje{
	var property dificultad
	override method habilidadParaLucha() = super() * self.dificultad().valorMultiplicador()
}

class Facil{
	method valorMultiplicador() = 1
}

class Moderado{
	method valorMultiplicador() = 2
}

class Dificil{
	method valorMultiplicador() = 4
}

/** Hechizos */
class Logos{
	var property nombre
	
	var property valorMultiplicador
	
	method poder() = self.valorMultiplicador() * self.nombre().length()
	
	method unidadesRefuerzo() = self.poder()
	
	method esPoderoso() = self.poder() > 15
	
	method estaVinculado() = false
	
	method claseHechizo() = true
	
	method precio() = self.poder()
	
	method precioVinculado() = true
	
	method precioRefuerzo(armadura) = armadura.unidadesBaseDeLucha() + self.precio()
	
	method peso() = if(self.poder().even()){return 2}else{return 1}

}


object hechizoBasico{
	
	method poder() = 10
	
	method unidadesRefuerzo() = self.poder()

	method esPoderoso() = false
	
	method estaVinculado() = false
	
	method claseHechizo() = true
	
	method precio() = self.poder()
	
	method precioVinculado() = true
	
	method precioRefuerzo(armadura) = armadura.unidadesBaseDeLucha() + self.precio()
	
}

class HechizoComercial inherits Logos{
	var property porcentaje = 0.2
	override method nombre() = "el hechizo comercial"
	override method valorMultiplicador() = 2
	override method poder() = super() * self.porcentaje()
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
	
	method precio() = 10 * self.hechizos().size() + self.poder()
}

/** Artefactos */

class Artefacto{
	const hoy = new Date()
	const property peso = 0
	const property diaDeCompra = hoy
	method diasDesdeCompra() = hoy - diaDeCompra 
	method factorDeCorreccion() = 1.min(self.diasDesdeCompra() / 1000)
	method pesoTotal() = self.peso() - self.factorDeCorreccion()
}

class Arma inherits Artefacto{
	method unidadesDeLucha() = 3
	method estaVinculado() = false
	method precio() = 5 * self.unidadesDeLucha()
}


object collarDivino inherits Artefacto{
	var property perlas = 5
	
	method unidadesDeLucha() = self.perlas()
	
	method estaVinculado() = false
	
	method precio() = 2 * self.perlas()
	
	override method pesoTotal() = super() + 0.5 * self.perlas()
}

class MascaraOscura inherits Artefacto{
	var property indiceDeOscuridad = 1
	var property valorMinimo = 4
	method unidadesDeLucha() = self.valorMinimo().max(fuerzaOscura.valorFuerzaOscura() * self.indiceDeOscuridad() / 2)
	method estaVinculado() = false
	method pesoExtra() = 0.max(self.unidadesDeLucha() - 3)
	override method pesoTotal() = super() + self.pesoExtra()
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


class Armadura inherits Artefacto{
	const property unidadesBaseDeLucha = 3
	
	var property refuerzo = ninguno
	
	method unidadesDeLuchadelRefuerzo(portador) = if(self.refuerzo().estaVinculado()){return self.refuerzo().unidadesRefuerzo(portador)}else{return self.refuerzo().unidadesRefuerzo()}
		
	method unidadesDeLucha(portador) = self.unidadesBaseDeLucha() + self.unidadesDeLuchadelRefuerzo(portador)
	
	method estaVinculado() = true
	
	method precio() = if(self.refuerzo().precioVinculado()){return self.refuerzo().precioRefuerzo(self)}else{return self.refuerzo().precioRefuerzo()}
	
	override method pesoTotal() = super() + self.refuerzo().peso()
}


/* Refuerzos Armadura*/

class CotaDeMalla{	
	var property unidadesRefuerzo
	method estaVinculado() = false
	method precioVinculado() = false
	method precioRefuerzo() = self.unidadesRefuerzo() / 2
	method peso() = 1
}


object bendicion{
	method estaVinculado() = true
	method precioVinculado() = true
	method unidadesRefuerzo(luchador) = luchador.nivelDeHechiceria()
	method precioRefuerzo(armadura) = armadura.unidadesBaseDeLucha()
	method peso() = 0
}

object ninguno{
	method estaVinculado() = false
	method precioVinculado() = false
	method unidadesRefuerzo() = 0
	method precioRefuerzo() = 2
	method peso() = 0
}
