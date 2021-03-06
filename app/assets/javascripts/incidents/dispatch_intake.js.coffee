class window.DispatchIntakeController
  constructor: () ->
    $('.collapse').collapse({toggle: false})

    $(document).on 'change', "input[id*='call_type']", (evt) =>
      val = $(evt.target).val()
      @updateCollapse(val)

      

    @addressSelector = "input[id$='address_entry']"
    $(document).on 'change', @addressSelector, (evt) =>
      @addressChanged(evt)
      evt.preventDefault()

    $(document).on 'keydown', (evt) =>
      if evt.keyCode == 13
        $(evt.target).trigger('change')
        evt.preventDefault()
        false
      true

    #$(document).on 'submit', (evt) =>
    #  console.log evt.target
    #  unless @allowSubmit
    #    evt.preventDefault()
#
    #$(document).on 'click', 'input[type=submit]', (evt) =>
    #  @allowSubmit = true
    #  true

    @geocoder = new google.maps.Geocoder()

    @updateCollapse($("input:checked[id*='call_type']").val())

  updateCollapse: (val) ->
    console.log val
    $('.local-emergency').collapse(@collapseAction(val == 'incident'))
    $('.referral').collapse(@collapseAction(val == 'referral'))
    @validIncident = (val == 'incident')

  addressChanged: (evt, val) ->
    evt.preventDefault() if evt?
    val ||= $(evt.target).val()
    $(@addressSelector).val(val)
    if @validIncident
      @updateDispatchAddress(val)
    else
      @updateReferralAddress(val)

  inputField: (fname) ->
    $("[id$=call_log_#{fname}]")

  setFieldVal: (fname, val) ->
    this.inputField(fname).val(val)

  getFieldVal: (fname) ->
    this.inputField(fname).val()

  collapseAction: (val) ->
    if val then 'show' else 'hide'

  updateAddressFields: (result) ->
    @setFieldVal('lat', result.lat)
    @setFieldVal('lng', result.lng)
    @setFieldVal('address', result.address)
    @setFieldVal('state', result.state)
    @setFieldVal('county', result.county)
    @setFieldVal('zip', result.zip)
    @setFieldVal('city', result.city)
    @setFieldVal('neighborhood', result.neighborhood)

  updateDispatchAddress: (addr) ->
    @geocodeAddress addr, (result) =>
      if !result?
        $('.county-name').text('_______')
      else
        $('.county-name').text(result.county)

        @updateAddressFields(result)

        @getResponseTerritory result, (response_territory) =>
          console.log response_territory
          if !response_territory? or !response_territory.permissions.create
            $('.inside-response-territory').collapse('hide')
            $('.outside-response-territory').collapse('show')
            number = if response_territory? then response_territory.dispatch_number else '855-891-7325'
            $('.dispatch-referral').text(number)
          else
            $('.inside-response-territory').collapse('show')
            $('.outside-response-territory').collapse('hide')
          @updateResponseTerritoryDisplay(response_territory)
          


  updateReferralAddress: (addr) ->
    @geocodeAddress addr, (result) =>
      if !result?
        $('.referral-county').text('_______')
      else
        $('.referral-county').text(result.county)

        @updateAddressFields(result)

        @getResponseTerritory result, (response_territory) =>
          number = if response_territory then response_territory.non_disaster_number else '800-RED-CROSS (800-733-2767)'
          $('.referral-number').text(number)
          @updateResponseTerritoryDisplay(response_territory)



  geocodeAddress: (addr, callback) ->
    @geocoder.geocode {address: addr}, (results, status) =>
      console.log status, results
      if (status != google.maps.GeocoderStatus.OK)
        callback(null)
      else
        result = results[0]
        loc =
          lat: result.geometry.location.lat()
          lng: result.geometry.location.lng()
          address: result.formatted_address.split(",")[0]
          city: MapHelper.getCity(result)
          state: MapHelper.getAddressComponent(result, 'administrative_area_level_1', 'short_name')
          zip: MapHelper.getAddressComponent(result, 'postal_code', 'long_name')
          county: MapHelper.filterCounty(MapHelper.getAddressComponent(result, 'administrative_area_level_2', 'long_name'))
        console.log loc
        callback(loc)

  updateResponseTerritoryDisplay: (response_territory) ->
    if response_territory?
      region = response_territory.region_name || ''
      name = response_territory.name || ''
    else
      region = ''
      name = ''
    $('.dispatch-region-name').text(region)
    $('.dispatch-response-territory-name').text(name)

    @setFieldVal 'region_id', response_territory.region_id
    @setFieldVal 'response_territory_id', response_territory.id

  getResponseTerritory: (data, callback) ->
    $.ajax
      url: '/incidents/api/response_territories.json'
      data:
        response_territory_lookup:
          data
      success: (result, status, xhr) ->
        callback(result)
      error: (xhr, status, error) ->
        console.log status, error
        if xhr.status == 404
          callback(null)



