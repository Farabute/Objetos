import Tp_objetos.*
import Artefactos.*
import Personajes.*


class Logos{
	var property nombre
	
	var property valorMultiplicador
	
	method poder() = self.valorMultiplicador() * self.nombre().length()
	
	method unidadesRefuerzo(luchador) = self.poder()
	
	method esPoderoso() = self.poder() > 15
	
	method precio() = self.poder()
	
	method precioRefuerzo(armadura) = armadura.unidadesBaseDeLucha() + self.precio()
	
	method pesoRefuerzo() = if(self.poder().even()){return 2}else{return 1}

}


object hechizoBasico{
	
	method poder() = 10
	
	method esPoderoso() = false
	
	method unidadesRefuerzo(luchador) = self.poder()
	
	method precio() = self.poder()
	
	method precioRefuerzo(armadura) = armadura.unidadesBaseDeLucha() + self.precio()
	
	method pesoRefuerzo() = 2
	
}

class HechizoComercial inherits Logos{
	var property porcentaje = 0.2
	override method nombre() = "el hechizo comercial"
	override method valorMultiplicador() = 2
	override method poder() = super() * self.porcentaje()
}

class LibroDeHechizos{
	var property hechizos = []
	
	method hechizosValidos() = self.hechizos().remove(self)
	
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
	
	method precio() = 10 * self.hechizos().size() + self.poder()
}
