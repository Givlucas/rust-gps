use nmea::Nmea;

fn main() {
    let mut nmea = Nmea::default();
    let gga = "$GPVTG,140.88,T,,M,8.04,N,14.89,K,D*05";
    // feature `GGA` should be enabled to parse this sentence.
    nmea.parse(gga).unwrap();
    println!("{}", nmea.speed_over_ground.unwrap());
}
