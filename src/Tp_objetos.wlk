import Artefactos.*
import LibroYHechizos.*
import Personajes.*





/** Comerciantes */

class Comerciante{
	var property tipoDeComerciante
	method valorCobrado(unPersonaje, unItem) = unItem.costo(unPersonaje) + self.tipoDeComerciante().impuestoAdicional(unItem.precio())
	method recategorizate() = self.tipoDeComerciante().recategorizate(self)
	
}

class ComercianteIndependiente{
	var property comision
	method impuestoAdicional(importe) = self.comision() * importe
	method duplicaTuImpuesto() = self.comision(self.comision() * 2)
	method recategorizate(unComerciante){
		self.duplicaTuImpuesto()
		if(self.comision() > 0.21){
			unComerciante.tipoDeComerciante(new ComercianteRegistrado())
		}
	}
}

class ComercianteRegistrado{
	method iva() = 0.21
	method impuestoAdicional(importe) = self.iva() * importe
	method recategorizate(unComerciante) = unComerciante.tipoDeComerciante(new ComercianteConImpuestoALasGanancias())
}

class ComercianteConImpuestoALasGanancias{
	const property minimoNoImponible = 5
	method impuestoAdicional(importe) = if(importe > self.minimoNoImponible()){return self.impuestoALasGanancias(importe)}else{return 0}
	method impuestoALasGanancias(importe) = (importe - self.minimoNoImponible()) * 0.35
	method recategorizate(unComerciante){}
}


