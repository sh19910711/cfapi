require "bundler/setup"

if ENV["TRAVIS"] == "true"
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require "codeforces"

require "vcr"
VCR.configure do |conf|
  conf.cassette_library_dir = "spec/api_fixtures"
  conf.hook_into :webmock
  conf.configure_rspec_metadata!
  conf.preserve_exact_body_bytes { true }
  conf.default_cassette_options = {
    :serialize_with => :psych,
    :re_record_interval => 24 * 3600,
  }
  conf.ignore_hosts "codeclimate.com"
end

require "webmock"
require "json"
RSpec.configure do |conf|
  conf.before do
    ::WebMock.stub_request(
      :get,
      "http://codeforces.com/api/user.ratedList",
    ).to_return(
      :status => 200,
      :body => '{"status":"OK","result":[{"handle":"tourist","firstName":"Gennady","lastName":"Korotkevich","country":"Belarus","city":"Gomel","organization":"NRU ITMO","contribution":33,"rank":"international grandmaster","rating":3254,"maxRank":"international grandmaster","maxRating":3299,"lastOnlineTimeSeconds":1422146844,"registrationTimeSeconds":1265987288},{"handle":"Petr","firstName":"Petr","lastName":"Mitrichev","country":"Russia","city":"Moscow","organization":"Google","contribution":143,"rank":"international grandmaster","rating":2893,"maxRank":"international grandmaster","maxRating":3002,"lastOnlineTimeSeconds":1422429465,"registrationTimeSeconds":1267103024},{"handle":"yeputons","firstName":"Egor","lastName":"Suvorov","country":"Russia","city":"Saint Petersburg","organization":"Saint-Petersburg SU","contribution":114,"rank":"international grandmaster","rating":2742,"maxRank":"international grandmaster","maxRating":2773,"lastOnlineTimeSeconds":1422572943,"registrationTimeSeconds":1270712095},{"handle":"subscriber","firstName":"Adam","lastName":"Bardashevich","country":"Belarus","city":"BLR","organization":"NRU ITMO","contribution":35,"rank":"international grandmaster","rating":2685,"maxRank":"international grandmaster","maxRating":2685,"lastOnlineTimeSeconds":1422600030,"registrationTimeSeconds":1270566853}]}',
      :headers => {
        "Content-Type" => "application/json",
      },
    )

    ::WebMock.stub_request(
      :get,
      "http://codeforces.com/api/problemset.problems",
    ).to_return(
      :status => 200,
      :body => {
        :status => "OK",
        :result => {
          :problems => [
            {"contestId" => 513,"index" => "G3","name" => "Inversions problem","type" => "PROGRAMMING","points" => 16.0,"tags" => ["dp"]},
            {"contestId" => 346,"index" => "A","name" => "Alice and Bob","type" => "PROGRAMMING","points" => 500.0,"tags" => ["games","math","number theory"]},
            {"contestId" => 250,"index" => "D","name" => "Building Bridge","type" => "PROGRAMMING","points" => 1500.0,"tags" => ["geometry","ternary search","two pointers"]},
            {"contestId" => 251,"index" => "D","name" => "Two Sets","type" => "PROGRAMMING","points" => 2000.0,"tags" => ["bitmasks","math"]},
            {"contestId" => 251,"index" => "C","name" => "Number Transformation","type" => "PROGRAMMING","points" => 1500.0,"tags" => ["dp","greedy","number theory"]},
            {"contestId" => 154,"index" => "E","name" => "Martian Colony","type" => "PROGRAMMING","points" => 2500.0,"tags" => ["geometry"]},
            {"contestId" => 154,"index" => "D","name" => "Flatland Fencing","type" => "PROGRAMMING","points" => 2000.0,"tags" => ["games","math"]},
            {"contestId" => 154,"index" => "C","name" => "Double Profiles","type" => "PROGRAMMING","points" => 1500.0,"tags" => ["graphs","hashing","sortings"]},
            {"contestId" => 154,"index" => "B","name" => "Colliders","type" => "PROGRAMMING","points" => 1000.0,"tags" => ["math","number theory"]},
            {"contestId" => 154,"index" => "A","name" => "Hometask","type" => "PROGRAMMING","points" => 500.0,"tags" => ["greedy"]},
            {"contestId" => 3,"index" => "C","name" => "Tic-tac-toe","type" => "PROGRAMMING","tags" => ["brute force","games","implementation"]},
            {"contestId" => 1,"index" => "B","name" => "Spreadsheet","type" => "PROGRAMMING","tags" => ["implementation","math"]},
          ],
          :problemStatistics => [
            {"contestId" => 513,"index" => "G3","solvedCount" => 19},{"contestId" => 513,"index" => "G2","solvedCount" => 253},{"contestId" => 513,"index" => "G1","solvedCount" => 1285},{"contestId" => 513,"index" => "F2","solvedCount" => 46},{"contestId" => 513,"index" => "F1","solvedCount" => 65},{"contestId" => 513,"index" => "E2","solvedCount" => 71},{"contestId" => 513,"index" => "E1","solvedCount" => 162},{"contestId" => 513,"index" => "D2","solvedCount" => 174},{"contestId" => 513,"index" => "D1","solvedCount" => 252},{"contestId" => 513,"index" => "C","solvedCount" => 929},{"contestId" => 513,"index" => "B2","solvedCount" => 1697},{"contestId" => 513,"index" => "B1","solvedCount" => 2612},{"contestId" => 513,"index" => "A","solvedCount" => 4382},{"contestId" => 512,"index" => "E","solvedCount" => 51},{"contestId" => 512,"index" => "D","solvedCount" => 71},{"contestId" => 510,"index" => "E","solvedCount" => 67},{"contestId" => 510,"index" => "D","solvedCount" => 349},{"contestId" => 510,"index" => "C","solvedCount" => 897},{"contestId" => 510,"index" => "B","solvedCount" => 2116},{"contestId" => 510,"index" => "A","solvedCount" => 4219},{"contestId" => 509,"index" => "F","solvedCount" => 238},{"contestId" => 509,"index" => "E","solvedCount" => 879},{"contestId" => 509,"index" => "D","solvedCount" => 315},{"contestId" => 509,"index" => "C","solvedCount" => 806},{"contestId" => 509,"index" => "B","solvedCount" => 2780},{"contestId" => 509,"index" => "A","solvedCount" => 4380},{"contestId" => 508,"index" => "E","solvedCount" => 494},{"contestId" => 508,"index" => "D","solvedCount" => 412},{"contestId" => 508,"index" => "C","solvedCount" => 1946},{"contestId" => 508,"index" => "B","solvedCount" => 3286},{"contestId" => 508,"index" => "A","solvedCount" => 3696},{"contestId" => 507,"index" => "E","solvedCount" => 633},{"contestId" => 507,"index" => "D","solvedCount" => 535},{"contestId" => 507,"index" => "C","solvedCount" => 1859},{"contestId" => 507,"index" => "B","solvedCount" => 3092},{"contestId" => 507,"index" => "A","solvedCount" => 4232},{"contestId" => 506,"index" => "E","solvedCount" => 20},{"contestId" => 506,"index" => "D","solvedCount" => 312},{"contestId" => 505,"index" => "E","solvedCount" => 18},{"contestId" => 505,"index" => "D","solvedCount" => 163},{"contestId" => 505,"index" => "C","solvedCount" => 555},{"contestId" => 505,"index" => "B","solvedCount" => 1746},{"contestId" => 505,"index" => "A","solvedCount" => 2600},{"contestId" => 504,"index" => "E","solvedCount" => 32},{"contestId" => 504,"index" => "D","solvedCount" => 89},{"contestId" => 501,"index" => "E","solvedCount" => 58},{"contestId" => 501,"index" => "D","solvedCount" => 234},{"contestId" => 501,"index" => "C","solvedCount" => 984},{"contestId" => 501,"index" => "B","solvedCount" => 2600},{"contestId" => 501,"index" => "A","solvedCount" => 3502},{"contestId" => 500,"index" => "G","solvedCount" => 17},{"contestId" => 500,"index" => "F","solvedCount" => 154},{"contestId" => 500,"index" => "E","solvedCount" => 512},{"contestId" => 500,"index" => "D","solvedCount" => 1407},{"contestId" => 500,"index" => "C","solvedCount" => 3024},{"contestId" => 500,"index" => "B","solvedCount" => 2927},{"contestId" => 500,"index" => "A","solvedCount" => 5446},{"contestId" => 499,"index" => "B","solvedCount" => 3612},{"contestId" => 499,"index" => "A","solvedCount" => 3586},{"contestId" => 498,"index" => "E","solvedCount" => 115},{"contestId" => 498,"index" => "D","solvedCount" => 296},{"contestId" => 498,"index" => "C","solvedCount" => 618},{"contestId" => 498,"index" => "B","solvedCount" => 368},{"contestId" => 498,"index" => "A","solvedCount" => 1155},{"contestId" => 497,"index" => "E","solvedCount" => 46},{"contestId" => 1,"index" => "C","solvedCount" => 1329},{"contestId" => 1,"index" => "B","solvedCount" => 4216},{"contestId" => 1,"index" => "A","solvedCount" => 20493}
          ],
        },
      }.to_json,
      :headers => {
        "Content-Type" => "application/json",
      },
    )

    ::WebMock.stub_request(
      :get,
      "http://codeforces.com/api/contest.list",
    ).to_return(
      :status => 200,
      :body => {
        :status => "OK",
        :result => [
          {"id" => 515,"name" => "Codeforces Round #292 (Div. 2)","type" => "CF","phase" => "BEFORE","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1424190600,"relativeTimeSeconds" => -285189},
          {"id" => 516,"name" => "Codeforces Round #292 (Div. 1)","type" => "CF","phase" => "BEFORE","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1424190600,"relativeTimeSeconds" => -285189},
          {"id" => 514,"name" => "Codeforces Round #291 (Div. 2)","type" => "CF","phase" => "BEFORE","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1423931400,"relativeTimeSeconds" => -25990},
          {"id" => 513,"name" => "Rockethon 2015","type" => "ICPC","phase" => "FINISHED","frozen" => false,"durationSeconds" => 11700,"startTimeSeconds" => 1423328400,"relativeTimeSeconds" => 577011},
          {"id" => 512,"name" => "Codeforces Round #290 (Div. 1)","type" => "CF","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7500,"startTimeSeconds" => 1422894600,"relativeTimeSeconds" => 1010811},
          {"id" => 510,"name" => "Codeforces Round #290 (Div. 2)","type" => "CF","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7500,"startTimeSeconds" => 1422894600,"relativeTimeSeconds" => 1010811},
          {"id" => 509,"name" => "Codeforces Round #289 (Div. 2, ACM ICPC Rules)","type" => "ICPC","phase" => "FINISHED","frozen" => false,"durationSeconds" => 10800,"startTimeSeconds" => 1422705600,"relativeTimeSeconds" => 1199811},
          {"id" => 508,"name" => "Codeforces Round #288 (Div. 2)","type" => "CF","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1422376200,"relativeTimeSeconds" => 1529211},
          {"id" => 507,"name" => "Codeforces Round #287 (Div. 2)","type" => "CF","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1422028800,"relativeTimeSeconds" => 1876611},
          {"id" => 505,"name" => "Codeforces Round #286 (Div. 2)","type" => "CF","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1421586000,"relativeTimeSeconds" => 2319411},
          {"id" => 506,"name" => "Codeforces Round #286 (Div. 1)","type" => "CF","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1421586000,"relativeTimeSeconds" => 2319411},
          {"id" => 501,"name" => "Codeforces Round #285 (Div. 2)","type" => "CF","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1421053200,"relativeTimeSeconds" => 2852211},
          {"id" => 504,"name" => "Codeforces Round #285 (Div. 1)","type" => "CF","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1421053200,"relativeTimeSeconds" => 2852211},
          {"id" => 154,"name" => "Codeforces Round #109 (Div. 1)","type" => "CF","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1330095600,"relativeTimeSeconds" => 93809811},
          {"id" => 140,"name" => "Codeforces Round #100","type" => "CF","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1325689200,"relativeTimeSeconds" => 98216211},
          {"id" => 12,"name" => "Codeforces Beta Round #12 (Div 2 Only)","type" => "ICPC","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1272538800,"relativeTimeSeconds" => 151366611},
          {"id" => 10,"name" => "Codeforces Beta Round #10","type" => "ICPC","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1271346300,"relativeTimeSeconds" => 152559111},
          {"id" => 2,"name" => "Codeforces Beta Round #2","type" => "ICPC","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1267117200,"relativeTimeSeconds" => 156788211},
          {"id" => 1,"name" => "Codeforces Beta Round #1","type" => "ICPC","phase" => "FINISHED","frozen" => false,"durationSeconds" => 7200,"startTimeSeconds" => 1266580800,"relativeTimeSeconds" => 157324611},
        ],
      }.to_json,
      :headers => {
        "Content-Type" => "application/json",
      },
    )
  end

end
