object casa {
    var cuentaBancaria = cuentaCorriente
    var gastosMes = 0
    var viveres = 0
    var reparaciones = 0
    var mantenimiento = minimo
    method mantenimiento(_mantenimiento){
        mantenimiento = _mantenimiento
    }
    method viveres(_viveres){
        viveres = _viveres
    }
    method viveres(){
        return viveres
    }
    method suficientesViveres(){
        return viveres >= 40
    }
    method hayQueReparar(){
        return reparaciones > 0
    }
    method casaEnOrden(){
        return self.suficientesViveres() and not self.hayQueReparar()
    }
    method reparar(){
        self.gasto(reparaciones)
        reparaciones = 0
    }
    method reparaciones(_reparaciones){
        reparaciones = _reparaciones
    }
    method reparaciones(){
        return reparaciones
    }
    method comprarViveres(porcentaje,calidad){
        self.validarCompraViveres(porcentaje,calidad)
        viveres = viveres + porcentaje
        self.gasto(porcentaje * calidad)
    }
    method validarCompraViveres(porcentaje,calidad){
        if(porcentaje  + viveres > 100){
            self.error("El porcentaje de viveres no puede superar el 100%")
        }
    }
    method saldo(){
        return cuentaBancaria.saldo()
    }
    method gasto(monto){
        cuentaBancaria.extraer(monto)
        gastosMes = gastosMes + monto
    }
    method gastosMes(){
        return gastosMes
    }
    method cambioMes(){
        mantenimiento.mantenimientoCasa(self)
        gastosMes = 0
    }
    method cuentaBancaria(_cuentaBancaria){
        cuentaBancaria = _cuentaBancaria
    }
}
object minimo{
    var calidad = 0
    method mantenimientoCasa(casa){
        self.mantenimientoViveres(casa)
    }
    method calidad(_calidad){
        calidad = _calidad
    }
    method calidad(){
        return calidad
    }
    method mantenimientoViveres(casa){
        if(not casa.suficientesViveres()){
            const viveresFaltantes = 40 - casa.viveres()
            casa.comprarViveres(viveresFaltantes,calidad)
        }
    }
}
object full{
    const calidad = 5
    method mantenimientoCasa(casa){
        self.mantenimientoViveres(casa)
        self.mantenimientoReparaciones(casa)
    }
    method mantenimientoViveres(casa){
        if(casa.casaEnOrden() && casa.viveres() < 100){
            casa.comprarViveres(100 - casa.viveres(),calidad)
        }else if (casa.viveres() < 40){
            casa.comprarViveres(40 - casa.viveres(),calidad)

        }
    }
    method mantenimientoReparaciones(casa){
        if(casa.hayQueReparar() and casa.saldo() >= casa.reparaciones()){
            casa.reparar()
        }
    }
}

object cuentaCorriente {
  var saldo = 0
  method saldo() {
    return saldo
  }
  method extraer(monto){
        saldo = saldo - monto
    }
  method depositar(monto){
    saldo = saldo + monto
  }
  method saldo(_saldo){
    saldo = _saldo
  }
}
object cuentaConGastos{
    var saldo = 0
    var costo = 0
    method depositar(monto){
        self.validarDeposito(monto)
        saldo = saldo + monto - costo
    }
    method extraer(monto){
        saldo = saldo - monto
    }
    method saldo(){
        return saldo
    }
    method validarDeposito(monto){
        if (monto <= costo){
            self.error("El monto a depositar debe ser mayor al costo de la transaccion")
        }
    }
    method costo(_costo){
        costo = _costo
    }
    method saldo(_saldo){
        saldo = _saldo
    }
}
object cuentaConvinada{
    var primaria = cuentaConGastos
    var secundaria = cuentaCorriente
    method saldo(){
        return 0.max(primaria.saldo()) + 0.max(secundaria.saldo())
    }
    method depositar(monto){
        primaria.depositar(monto)
    }
    method extraer(monto){
        self.validarExtraccion(monto)
        if (primaria.saldo() - monto >= 0){
            primaria.extraer(monto)
        } else {
            const faltante = monto - 0.max(primaria.saldo())
            secundaria.extraer(faltante)
            primaria.saldo(0)
        }
    }
    method validarExtraccion(monto){
        if (monto > self.saldo()){
            self.error("No hay suficiente saldo")
        }
    }
    method primaria(_primaria){
        primaria = _primaria
    }
    method secundaria(_secundaria){
        secundaria = _secundaria
    }
}

/*
Reflexionar sobre los conceptos
Elegir un polimorfirmos e indicar:

1)Qué nombre le pondrías al tipo de los objetos polimórficos.
2)Qué mensajes componen ese tipo.
3)Quiénes usan los mensajes polimórficos.

1)estrategiaMantenimiento
2)mantenimientoCasa y mantenimientoViveres
3)casa con cambioMes 
*/

/*
Mencionar un mensaje que sea una orden y otro que sea una consulta
Orden: comprarViveres
Consulta: casaEnOrden

*/