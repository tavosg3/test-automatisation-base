Feature: Test de API súper simple

  Background:
    * configure ssl = true

  @id:1 @ObtenerTodosPersonajes
  Scenario: Verificar que un endpoint público responde 200
    Given url 'http://localhost:8080/testuser/api/characters'
    When method GET
    Then status 200
    And print response

  @id:2 @ObtenerPersonajePorID
  Scenario: Verificar que retorna el personaje correcto por ID
    Given url 'http://localhost:8080/testuser/api/characters'
    When method GET
    Then status 200
    And match response.id == 30

  @id:3 @NoEncuetraPersonajePorID
  Scenario: No encuentra personaje dado el ID
    Given url 'http://localhost:8080/testuser/api/characters/999'
    When method GET
    Then status 404
    And match response.message == "Character not found"

  @id:4 @EscenarioCreaPersonaje
  Scenario: Crea nuevo personaje
    Given url 'http://localhost:8080/testuser/api/characters'
    And request
    """
    {
      "name": "Ant Man",
      "alterego": "Scott Lang",
      "description": "Common Person",
      "powers": ["Small", "Giant"]
    }
    """
    When method POST
    Then status 201
    And match response ==
    """
    {
    "id": 1610,
    "name": "Ant Man",
    "alterego": "Scott Langk",
    "description": "Common Person",
    "powers": [
        "Small",
        "Giant"
      ]
    }
    """

  @id:5 @EscenarioCreaPersonajeDuplicado
  Scenario: Intenta crear personaje con nombre duplicado
    Given url 'http://localhost:8080/testuser/api/characters'
    And request
    """
    {
      "name": "Ant Man",
      "alterego": "Scott Langk",
      "description": "Common Person",
      "powers": ["Small","Giant"]
    }
    """
    When method POST
    Then status 400
    And match response ==
    """
    {
      "error": "Character name already exists"
    }
    """


  @id:6 @EscenarioCreaPersonajeFaltanCamposObligatoriosDuplicado
  Scenario: Intenta crear personaje con campos requeridos faltantes duplicado
    Given url 'http://localhost:8080/testuser/api/characters'
    And request
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """
    When method POST
    Then status 400
    And match response ==
    """
    {
      "name": "Name is required",
      "description": "Description is required",
      "powers": "Powers are required",
      "alterego": "Alterego is required"
    }
    """

  @id:7 @EscenarioActualizarPersonaje
  Scenario: Actualizar un personaje existente
    Given url 'http://localhost:8080/testuser/api/characters/1610'
    And request
    """
    {
      "name": "Ant Man",
      "alterego": "Scott Langk",
      "description": "Divorced Person",
      "powers": ["Small", "Giant"]
    }
    """
    When method PUT
    Then status 200
    And match response ==
    """
    {
      "id": 1610,
      "name": "Ant Man",
      "alterego": "Scott Langk",
      "description": "Divorced Person",
      "powers": ["Small", "Giant"]
    }
    """

  @id:8 @EscenarioActualizarPersonajeInexistente#
  Scenario: Intenta actualizar un personaje que no existe
    Given url 'http://localhost:8080/testuser/api/characters/9999'
    And request
    """
    {
      "name": "Ant Man",
      "alterego": "Scott Langk",
      "description": "Divorced Person",
      "powers": ["Small", "Giant"]
    }
    """
    When method PUT
    Then status 404
    And match response ==
    """
    {
      "error": "Character not found"
    }
    """

  @id:9 @EscenarioEliminarPersonaje#
  Scenario: Eliminar un personaje
    Given url 'http://localhost:8080/testuser/api/characters/1610'
    When method DELETE
    Then status 204
    And match response == ''

  @id:10 @EscenarioEliminarPersonaje#
  Scenario:  Intentar eliminar un personaje inexistente
    Given url 'http://localhost:8080/testuser/api/characters/9999'
    When method DELETE
    Then status 404
    And match response ==
    """
    {
      "error": "Character not found"
    }
    """