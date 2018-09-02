
object fuerzaOscura{
	var valorFuerzaOscura = 5
	
	method valorFuerzaOscura() = valorFuerzaOscura
	
	method eclipse() {
		valorFuerzaOscura =  valorFuerzaOscura*2
	}
	
}

object ninguno{
	method aporte() = 0
}

object espadaDelDestino{
	method aporte() = 3
}

object collarDivino{
	var perlas
	
	method numeroPerlas(numero) {
		perlas = numero
	}
	
	method perlas() = perlas	
	
	method aporte() = self.perlas()
}

object mascaraOscura {
	
	method aporte() = 
	if(fuerzaOscura.valorFuerzaOscura() < 8){
		return 4
	}
	else{
		return (fuerzaOscura.valorFuerzaOscura() / 2)
	}
	
}

object armadura{
	
	var refuerzo = ninguno
	
	method refuerzo(unRefuerzo){
		refuerzo = unRefuerzo
	}
	
	method refuerzo() = refuerzo
	
	method aporte() = 2 + refuerzo.aporte()
	
}

object cotaDeMalla{
	
	method aporte() = 1
}

object bendicion{
	
	var luchador
	
	method aporte() = luchador.nivelHechiceria()
	
	method luchador(unLuchador){
		luchador = unLuchador
	} 
}

object espejoFantastico{
	var portador
	method portador(luchador){
		portador = luchador
	}
	method aporte() = portador.aporteMejorObjeto()
}

object libroHechizos{
	
	var hechizos = []
	
	method aporte() = hechizos.sum({hechizo => hechizo.aporte()})
}

object rolando {

	var hechizoPreferido = espectroMalefico
	
	var valorBaseLucha = 1
	
	var artefactos = []
	
	method valorBase() = 3
	
	method valorBaseLucha() = valorBaseLucha
	
	method nuevoValorBaseLucha(valor){
		valorBaseLucha = valor
	}
	
	method hechizoPreferido(hechizo){
		hechizoPreferido = hechizo
	}
	
	method poderHechizoPreferido() = hechizoPreferido.poderHechizo()
	
	method nivelHechiceria() = ((self.valorBase()*self.poderHechizoPreferido()) + fuerzaOscura.valorFuerzaOscura())
	
	method seCreePoderoso() = (hechizoPreferido.esPoderoso())
	
	method agregarArtefacto(artefacto){
		artefactos.add(artefacto)
	}
	
	method quitarArtefacto(artefacto){
		artefactos.remove(artefacto)
	}
	
	method valorLuchaTotal() = 1 + artefactos.sum({artefacto => artefacto.aporte()})

	method mayorHabilidadLucha() = (self.valorLuchaTotal() > self.nivelHechiceria())

	method mejorObjeto() = artefactos.max({artefacto => artefacto.aporte()})
	
	method aporteMejorObjeto() = 
	if(artefactos.contains(espejoFantastico) and artefactos.equals(artefactos.size(),1))
	{
		return 0
	}
	else
	{
		return (self.mejorObjeto()).aporte()
	}

	method estaCargado() = (artefactos.size() >= 5)

}


object espectroMalefico {
	var nombre = "espectro malefico"
	
	method cambiarNombre(nuevoNombre){
		nombre = nuevoNombre
	}
	
	method poderHechizo() = nombre.size()
	
	method esPoderoso() = (self.poderHechizo() > 15)
	
	method aporte() = self.poderHechizo()
}

object hechizoBasico{
	
	method poderHechizo() = 10
	
	method esPoderoso() = false
	
	method aporte() = self.poderHechizo()
	
}
