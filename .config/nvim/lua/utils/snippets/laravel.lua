local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
  -- Controller methods
  s("lcontroller", fmt([[
    <?php

    namespace App\Http\Controllers;

    use Illuminate\Http\Request;
    
    class {}Controller extends Controller
    {{
        /**
         * Display a listing of the resource.
         */
        public function index()
        {{
            {}
        }}
    
        /**
         * Show the form for creating a new resource.
         */
        public function create()
        {{
            {}
        }}
    
        /**
         * Store a newly created resource in storage.
         */
        public function store(Request $request)
        {{
            {}
        }}
    
        /**
         * Display the specified resource.
         */
        public function show(string $id)
        {{
            {}
        }}
    
        /**
         * Show the form for editing the specified resource.
         */
        public function edit(string $id)
        {{
            {}
        }}
    
        /**
         * Update the specified resource in storage.
         */
        public function update(Request $request, string $id)
        {{
            {}
        }}
    
        /**
         * Remove the specified resource from storage.
         */
        public function destroy(string $id)
        {{
            {}
        }}
    }}
  ]], {
    i(1, "Resource"),
    i(2, "// return view"),
    i(3, "// return view"),
    i(4, "// validate and store"),
    i(5, "// find and return"),
    i(6, "// find and return view"),
    i(7, "// validate, find and update"),
    i(8, "// find and delete"),
  })),

  -- Model definition
  s("lmodel", fmt([[
    <?php

    namespace App\Models;

    use Illuminate\Database\Eloquent\Factories\HasFactory;
    use Illuminate\Database\Eloquent\Model;
    
    class {} extends Model
    {{
        use HasFactory;
        
        protected $fillable = [
            {}
        ];
        
        {}
    }}
  ]], {
    i(1, "ModelName"),
    i(2, "'name', 'email', 'password'"),
    i(3, "// Relationships here"),
  })),

  -- Relationship methods
  s("lbelongsto", fmt([[
    /**
     * Get the {} that owns the {}.
     */
    public function {}()
    {{
        return $this->belongsTo({});
    }}
  ]], {
    i(1, "parent"),
    i(2, "current model"),
    i(3, "relationshipName"),
    i(4, "ParentModel::class"),
  })),

  s("lhasmany", fmt([[
    /**
     * Get the {} for the {}.
     */
    public function {}()
    {{
        return $this->hasMany({});
    }}
  ]], {
    i(1, "children"),
    i(2, "current model"),
    i(3, "relationshipName"),
    i(4, "ChildModel::class"),
  })),

  -- Migration
  s("lmigration", fmt([[
    <?php

    use Illuminate\Database\Migrations\Migration;
    use Illuminate\Database\Schema\Blueprint;
    use Illuminate\Support\Facades\Schema;
    
    return new class extends Migration
    {{
        /**
         * Run the migrations.
         */
        public function up(): void
        {{
            Schema::create('{}', function (Blueprint $table) {{
                $table->id();
                {}
                $table->timestamps();
            }});
        }}
    
        /**
         * Reverse the migrations.
         */
        public function down(): void
        {{
            Schema::dropIfExists('{}');
        }}
    }};
  ]], {
    i(1, "table_name"),
    i(2, "$table->string('name');"),
    rep(1),
  })),

  -- Form request
  s("lrequest", fmt([[
    <?php

    namespace App\Http\Requests;

    use Illuminate\Foundation\Http\FormRequest;
    
    class {}Request extends FormRequest
    {{
        /**
         * Determine if the user is authorized to make this request.
         */
        public function authorize(): bool
        {{
            return {};
        }}
    
        /**
         * Get the validation rules that apply to the request.
         *
         * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array|string>
         */
        public function rules(): array
        {{
            return [
                {}
            ];
        }}
    }}
  ]], {
    i(1, "Store"),
    c(2, {
      t("true"),
      t("false"),
    }),
    i(3, "'email' => 'required|email',"),
  })),

  -- Blade form
  s("lform", fmt([[
    <form method="POST" action="{{ route('{}') }}">
        @csrf
        {}
        
        <div class="mb-4">
            <label for="{}" class="block text-sm font-medium text-gray-700">
                {}
            </label>
            <input type="{}" name="{}" id="{}" value="{{ old('{}') }}" 
                   class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
            @error('{}')
                <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
            @enderror
        </div>
        
        <div class="flex items-center justify-end mt-4">
            <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                {}
            </button>
        </div>
    </form>
  ]], {
    i(1, "users.store"),
    i(2, "@method('PUT')"),
    i(3, "email"),
    i(4, "Email Address"),
    i(5, "email"),
    rep(3),
    rep(3),
    rep(3),
    rep(3),
    i(6, "Submit"),
  })),

  -- Blade component
  s("lcomponent", fmt([[
    <x-{} class="{}">
        {{ ${} }}
    </x-{}>
  ]], {
    i(1, "component-name"),
    i(2, "mt-4"),
    i(3, "slot"),
    rep(1),
  })),

  -- Factory
  s("lfactory", fmt([[
    <?php

    namespace Database\Factories;

    use App\Models\{};
    use Illuminate\Database\Eloquent\Factories\Factory;
    
    class {}Factory extends Factory
    {{
        /**
         * Define the model's default state.
         *
         * @return array<string, mixed>
         */
        public function definition(): array
        {{
            return [
                {}
            ];
        }}
    }}
  ]], {
    i(1, "User"),
    rep(1),
    i(2, "'name' => fake()->name(),"),
  })),

  -- Routes group
  s("lroutes", fmt([[
    Route::middleware(['{}'])->group(function () {{
        Route::{}('{}', {}Controller::class);
    }});
  ]], {
    i(1, "auth"),
    i(2, "resource"),
    i(3, "users"),
    i(4, "User"),
  })),
}