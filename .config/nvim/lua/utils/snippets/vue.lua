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
  -- Vue 3 Component with <script setup>
  s("v3setup", fmt([[
    <template>
      <div>
        {}
      </div>
    </template>
    
    <script setup>
    {}
    
    defineProps({{
      {}
    }})
    
    {}
    </script>
    
    <style scoped>
    {}
    </style>
  ]], {
    i(1, "Component content here"),
    i(2, "import { ref, computed, onMounted } from 'vue'"),
    i(3, "modelValue: {type: String, required: true}"),
    i(4, "const count = ref(0)"),
    i(5, "/* component styles */"),
  })),

  -- Vue 3 Component with TypeScript
  s("v3ts", fmt([[
    <template>
      <div>
        {}
      </div>
    </template>
    
    <script setup lang="ts">
    import {{ ref, computed, onMounted }} from 'vue'
    
    interface Props {{
      {}
    }}
    
    const props = defineProps<Props>()
    
    {}
    </script>
    
    <style scoped>
    {}
    </style>
  ]], {
    i(1, "Component content here"),
    i(2, "modelValue: string"),
    i(3, "const count = ref<number>(0)"),
    i(4, "/* component styles */"),
  })),

  -- Vue 3 Composition API
  s("v3comp", fmt([[
    <template>
      <div>
        {}
      </div>
    </template>
    
    <script>
    import {{ defineComponent, ref, computed, onMounted }} from 'vue'
    
    export default defineComponent({{
      name: '{}',
      props: {{
        {}
      }},
      setup(props, {{ emit }}) {{
        {}
        
        return {{
          {}
        }}
      }}
    }})
    </script>
    
    <style scoped>
    {}
    </style>
  ]], {
    i(1, "Component content here"),
    i(2, "ComponentName"),
    i(3, "modelValue: {type: String, required: true}"),
    i(4, "const count = ref(0)"),
    i(5, "count"),
    i(6, "/* component styles */"),
  })),

  -- Vue 3 Composition API with TypeScript
  s("v3compts", fmt([[
    <template>
      <div>
        {}
      </div>
    </template>
    
    <script lang="ts">
    import {{ defineComponent, ref, computed, onMounted, PropType }} from 'vue'
    
    interface User {{
      id: number
      name: string
    }}
    
    export default defineComponent({{
      name: '{}',
      props: {{
        {}
      }},
      setup(props, {{ emit }}) {{
        {}
        
        return {{
          {}
        }}
      }}
    }})
    </script>
    
    <style scoped>
    {}
    </style>
  ]], {
    i(1, "Component content here"),
    i(2, "ComponentName"),
    i(3, "user: {type: Object as PropType<User>, required: true}"),
    i(4, "const count = ref<number>(0)"),
    i(5, "count"),
    i(6, "/* component styles */"),
  })),

  -- Vue ref
  s("vref", fmt([[
    const {} = ref({})
  ]], {
    i(1, "name"),
    i(2, "''"),
  })),

  -- Vue computed
  s("vcomputed", fmt([[
    const {} = computed(() => {})
  ]], {
    i(1, "computed"),
    i(2, "return props.modelValue")
  })),

  -- Vue watch
  s("vwatch", fmt([[
    watch({}, (newValue, oldValue) => {{
      {}
    }})
  ]], {
    i(1, "count"),
    i(2, "console.log('count changed:', newValue)"),
  })),

  -- Vue watchEffect
  s("vwatcheffect", fmt([[
    watchEffect(() => {{
      {}
    }})
  ]], {
    i(1, "console.log('count is:', count.value)"),
  })),

  -- Vue onMounted
  s("vonmounted", fmt([[
    onMounted(() => {{
      {}
    }})
  ]], {
    i(1, "// Component mounted logic"),
  })),

  -- Vue lifecycle hooks
  s("vlifecycle", fmt([[
    onMounted(() => {{
      {}
    }})
    
    onBeforeMount(() => {{
      {}
    }})
    
    onBeforeUnmount(() => {{
      {}
    }})
    
    onUnmounted(() => {{
      {}
    }})
  ]], {
    i(1, "console.log('Component mounted')"),
    i(2, "console.log('Component about to mount')"),
    i(3, "console.log('Component about to unmount')"),
    i(4, "console.log('Component unmounted')"),
  })),

  -- Vue emit
  s("vemit", fmt([[
    const emit = defineEmits<{{
      {}
    }}>()
    
    function {} () {{
      emit('{}', {})
    }}
  ]], {
    i(1, "(e: 'update:modelValue', value: string): void"),
    i(2, "updateValue"),
    i(3, "update:modelValue"),
    i(4, "newValue"),
  })),

  -- Vue v-for
  s("vfor", fmt([[
    <{} v-for="{} in {}" :key="{}.{}">
      {}
    </{}>
  ]], {
    i(1, "div"),
    i(2, "item"),
    i(3, "items"),
    rep(2),
    i(4, "id"),
    i(5, "{{ item.name }}"),
    rep(1),
  })),

  -- Vue v-if/else
  s("vif", fmt([[
    <{} v-if="{}">
      {}
    </{}>
    <{} v-else>
      {}
    </{}>
  ]], {
    i(1, "div"),
    i(2, "isVisible"),
    i(3, "Content when condition is true"),
    rep(1),
    rep(1),
    i(4, "Content when condition is false"),
    rep(1),
  })),
}