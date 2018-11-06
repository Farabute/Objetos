import Artefactos.*
import LibroYHechizos.*
import Personajes.*





/** Comerciantes */

class Comerciante{
	var property tipoDeComerciante
	
}

class ComercianteIndependiente inherits Comerciante{
	var property impuestoAdicional
	method impuestoAdicional(importe) = self.impuestoAdicional() * importe
	method duplicaTuImpuesto() = self.impuestoAdicional(self.impuestoAdicional() * 2)
	method recategorizate(){
		self.duplicaTuImpuesto()
		if(self.impuestoAdicional() > 0.21){self.tipoDeComerciante(new ComercianteRegistrado())}
		return self
	}
}

class ComercianteRegistrado inherits Comerciante{
	method impuestoAdicional(importe) = 0.21 * importe
	method recategorizate() = self.tipoDeComerciante(new ComercianteConImpuestoALasGanancias())
}

class ComercianteConImpuestoALasGanancias inherits Comerciante{
	const property minimoNoImponible
	method impuestoAdicional(importe) = if(importe > self.minimoNoImponible()){return self.impuestoALasGanancias(importe)}else{return 0}
	method impuestoALasGanancias(importe) = (importe - self.minimoNoImponible()) * 0.35
	method recategorizate(){}
}


