// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PokemonFactory {

  struct Pokemon {
    uint id;
    string name;
    Ability[] abilites;
    Types[] types;
    Weakness[] weaknesses;
  }

  struct Weakness{
    uint8 idType;
    uint8[] list;
  }

  struct Ability{
    string name;
    string description;
  }

  event eventNewPokemon(
    uint indexed _id,
    string indexed _name
  );

  Pokemon[] private pokemons;

  enum Types { Normal, Fuego, Agua, Planta, Electrico, Hielo, Lucha, Veneno, Tierra, Volador, Psiquico, Bicho, Roca, Fantasma, Dragon, Siniestro, Acero, Hada }

  mapping (uint => address) public pokemonToOwner;
  mapping (address => uint) ownerPokemonCount;
  mapping (uint8 => uint8[]) weaknesses;

  constructor () {
    weaknesses[uint8(Types.Normal)] = [uint8(Types.Lucha)];
    weaknesses[uint8(Types.Fuego)] = [uint8(Types.Agua), uint8(Types.Tierra), uint8(Types.Roca)];
    weaknesses[uint8(Types.Agua)] = [uint8(Types.Planta), uint8(Types.Electrico)];
    weaknesses[uint8(Types.Planta)] = [uint8(Types.Fuego), uint8(Types.Hielo), uint8(Types.Veneno), uint8(Types.Volador), uint8(Types.Bicho)];
    weaknesses[uint8(Types.Electrico)] = [uint8(Types.Tierra)];
    weaknesses[uint8(Types.Hielo)] = [uint8(Types.Fuego), uint8(Types.Lucha), uint8(Types.Roca), uint8(Types.Acero)];
    weaknesses[uint8(Types.Lucha)] = [uint8(Types.Volador), uint8(Types.Psiquico), uint8(Types.Hada)];
    weaknesses[uint8(Types.Veneno)] = [uint8(Types.Tierra), uint8(Types.Psiquico)];
    weaknesses[uint8(Types.Tierra)] = [uint8(Types.Agua), uint8(Types.Planta), uint8(Types.Hielo)];
    weaknesses[uint8(Types.Volador)] = [uint8(Types.Electrico), uint8(Types.Hielo), uint8(Types.Roca)];
    weaknesses[uint8(Types.Psiquico)] = [uint8(Types.Bicho), uint8(Types.Fantasma), uint8(Types.Siniestro)];
    weaknesses[uint8(Types.Bicho)] = [uint8(Types.Volador), uint8(Types.Roca), uint8(Types.Fuego)];
    weaknesses[uint8(Types.Roca)] = [uint8(Types.Agua), uint8(Types.Planta), uint8(Types.Lucha), uint8(Types.Tierra), uint8(Types.Acero)];
    weaknesses[uint8(Types.Fantasma)] = [uint8(Types.Fantasma), uint8(Types.Siniestro)];
    weaknesses[uint8(Types.Dragon)] = [uint8(Types.Hielo), uint8(Types.Dragon), uint8(Types.Hada)];
    weaknesses[uint8(Types.Siniestro)] = [uint8(Types.Hielo), uint8(Types.Dragon), uint8(Types.Hada)];
    weaknesses[uint8(Types.Acero)] = [uint8(Types.Fuego), uint8(Types.Lucha), uint8(Types.Tierra)];
    weaknesses[uint8(Types.Hada)] = [uint8(Types.Veneno), uint8(Types.Acero)];
  }


  function createPokemon (string calldata _name, uint  _id,Types[] memory _types, Ability[] memory _abilities) public {
    require(_id > 0, "The id must be greater than 0");
    /*
    Solo funciona corretamente para caracteres simples
    https://betterprogramming.pub/in-the-world-of-javascript-finding-the-length-of-string-is-such-an-easy-thing-just-do-str-length-4b4b33dbed09
    */
    require(bytes(_name).length > 2, "The name must be greater than 0");

    pokemons.push();
    uint index = pokemons.length - 1;
    pokemons[index].id = _id;
    pokemons[index].name = _name;

    for (uint i = 0; i < _types.length; i++ ) {
      pokemons[index].types.push(_types[i]);
      pokemons[index].weaknesses.push(Weakness(uint8(_types[i]), weaknesses[uint8(_types[i])]));
    }

    for (uint i = 0; i < _abilities.length; i++) {
      pokemons[index].abilites.push(_abilities[i]);
    }

    pokemonToOwner[_id] = msg.sender;
    ownerPokemonCount[msg.sender]++;
    emit eventNewPokemon(_id, _name);
  }

  function getAllPokemons() public view returns (Pokemon[] memory) {
    return pokemons;
  }

  function getWeaknesses(uint8 _type) public view returns(uint8[] memory){
    return weaknesses[_type];
  }
}
