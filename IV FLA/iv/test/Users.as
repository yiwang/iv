class Users {
  private static var numInstances:Number = 0;
  function Users() {
    numInstances++;
  }
  static function get instances():Number {
    return numInstances;
  }
}
