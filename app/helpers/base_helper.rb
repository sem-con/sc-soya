module BaseHelper
    def getAttributes(input)
        return input["@graph"].map{|e| e["@id"] unless e["domain"].nil?}.compact rescue []
    end

    def getSoyaName(input)
        base_url = input["@context"]["@base"].to_s rescue ""
        return base_url.split('/')[-1] rescue ""
    end

    def createDriVersion(input)

puts "Input ======"
puts input.to_json


        base_url = input["@context"]["@base"] rescue ""
        input["@context"].delete("@base") rescue nil
        raw = iterate(JSON.parse(input.to_json_c14n)).to_json_c14n
        dri = Multibases.pack("base58btc", Multihashes.encode(Digest::SHA256.digest(raw), "sha2-256").unpack('C*')).to_s
        raw = JSON.parse(raw)
        raw["@context"]["@base"] = base_url.split('/')[0..-2].join("/") + "/" + dri + "/"
        return raw
    end

    def calculateDri(input)
        input["@context"].delete("@base") rescue nil
        raw = iterate(JSON.parse(input.to_json_c14n)).to_json_c14n
        return Multibases.pack("base58btc", Multihashes.encode(Digest::SHA256.digest(raw), "sha2-256").unpack('C*')).to_s
    end

    def checkDRI(val)
        pos = (val =~ /zQm[1-9A-HJ-NP-Za-km-z]{44}/)
        if pos.nil?
          return val
        else
          if val =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
            return val[pos..(pos+46)]
          else
            return val
          end
        end
    end

    def iterate(i)
      if i.is_a?(Hash)
        i.each do |k, v|
          if v.is_a?(Hash) || v.is_a?(Array)
            iterate(v)
          else
            i[k] = checkDRI(v)
          end
        end
      elsif i.is_a?(Array)
        i.map! do |v|
          if v.is_a?(String)
            checkDRI(v)
          else
            iterate(v)
          end
        end
      end
    end

end