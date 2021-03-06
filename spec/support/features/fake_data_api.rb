module FakeDataApis
  def set_data_api_to(data_api)
    DefenceRequestServiceRota.register_service(:auth_api, data_api)
  end

  class FakeLawFirmsApi
    def initialize(token)
      @token = token
    end

    def organisations(options = {})
      if options[:uids]
        options[:uids].flat_map { |uid| law_firms.select { |law_firm| law_firm.uid == uid } }
      else
        law_firms
      end
    end

    private

    def law_firms
      [
        OpenStruct.new(
          uid: "32252f6a-a6a5-4f52-8ede-58d6127ba231",
          name: "Guilded Groom & Groom",
          type: "law_firm",
          links: { "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3" }
        ),
        OpenStruct.new(
          uid: "e9001714-2cc0-4cc9-b8a4-e7e1d1368da9",
          name: "The Impecably Suited Co.",
          type: "law_office",
          links: { "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3" }
        ),
      ]
    end
  end

  class FakeLocationsApi
    def initialize(token)
      @token = token
    end

    def organisation(uid)
      locations.detect { |org| org.uid == uid }
    end

    def organisations(options = {})
      if options[:uids]
        options[:uids].flat_map { |uid| locations.select { |location| location.uid == uid } }
      else
        locations
      end
    end

    private

    def locations
      [
        OpenStruct.new(
          uid: "e6256f3b-3920-4e5c-a8e1-5b6277985ca1",
          name: "Brighton Custody Suite",
          type: "custody_suite",
          links: { "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3" }
        ),
        OpenStruct.new(
          uid: "93b8ef50-fe12-4d80-9e7e-05e98232ec13",
          name: "Brighton Magistrates Court",
          type: "court",
          links: { "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3" }
        ),
      ]
    end
  end

  class FullDataStore
    def initialize(token)
      @token = token
    end

    def organisations(options = {})
      if options[:uids]
        options[:uids].flat_map { |uid| full_organisation_set.select { |org| org.uid == uid } }
      else
        full_organisation_set
      end
    end

    private

    def full_organisation_set
      [
        OpenStruct.new(
          uid: "32252f6a-a6a5-4f52-8ede-58d6127ba231",
          name: "Guilded Groom & Groom",
          type: "law_firm",
          links: { "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3" }
        ),
        OpenStruct.new(
          uid: "e9001714-2cc0-4cc9-b8a4-e7e1d1368da9",
          name: "The Impecably Suited Co.",
          type: "law_office",
          links: { "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3" }
        ),
        OpenStruct.new(
          uid: "e6256f3b-3920-4e5c-a8e1-5b6277985ca1",
          name: "Brighton Custody Suite",
          type: "custody_suite",
          links: { "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3" }
        ),
        OpenStruct.new(
          uid: "93b8ef50-fe12-4d80-9e7e-05e98232ec13",
          name: "Brighton Magistrates Court",
          type: "court",
          links: { "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3" }
        ),
      ]
    end
  end
end
