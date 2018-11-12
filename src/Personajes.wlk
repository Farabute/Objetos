import Tp_objetos.*
import Artefactos.*
import LibroYHechizos.*

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

	method artefactoMasPoderoso() = self.artefactos().filter({artefacto => artefacto != espejoFantastico}).max({artefacto => artefacto.unidadesDeLucha(self)})
	
	method habilidadParaLucha() = self.valorBaseLucha() + self.valorDeLuchaDeArtefactos(self)
	
	method valorDeLuchaDeArtefactos(duenio) = self.artefactos().sum({artefacto => artefacto.unidadesDeLucha(duenio)})
	
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
	
	method podesCostear(unItem, unComerciante) = self.monedas() >= unComerciante.valorCobrado(self, unItem)
	
	method cargaDePesoActual() = self.artefactos().sum({artefacto => artefacto.peso()})
	
	method podesCargarArtefacto(unArtefacto) = (unArtefacto.peso() + self.cargaDePesoActual()) <= self.pesoMaximo()
	
	method compra(unArtefacto){
		const comercianteSinComision = new Comerciante(tipoDeComerciante = new ComercianteIndependiente(comision = 0))
		self.compraleA(comercianteSinComision, unArtefacto)
	}
	
	method compraleA(unComerciante, unItem){
		if (!self.podesCostear(unItem, unComerciante)) {
			throw new ExcepcionPorFaltaDeMonedas("El luchador no dispone de las monedas suficientes para realizar la compra.")
		}
		if (!self.podesCargarArtefacto(unItem)) {
			throw new ExcepcionPorExcesoDePeso("El luchador no puede cargar con el objeto seleccionado, libere su inventario.")
		}
		self.restarNMonedas(unComerciante.valorCobrado(self, unItem))
		unItem.sosAdquirido(self)
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

class ExcepcionPorFaltaDeMonedas inherits Exception{}
class ExcepcionPorExcesoDePeso inherits Exception{}
