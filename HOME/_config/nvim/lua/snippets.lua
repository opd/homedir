local module = {}

local function _copy(args)
	return args[1]
end

local function add_snippets(ls)
  local t = ls.text_node
  local s = ls.snippet
  local i = ls.insert_node
  local f = ls.function_node
  local copy = function (index) return f(_copy, index)  end
  local makeRequest = {
    t("makeRequest("),
    i(1),
    t({
      ").then((response) => {",
      "  AppToaster.success('Object saved');",
      "}, AppToaster.defaultError);",
    }),
  }
  local fcReact = {
    t("interface "),
    copy(1),
    t({
      "Props {",
      "  id: string;",
      "}",
      "const ",
    }),
    i(1),
    t(": React.FC<"),
    copy(1),
    t({
      "Props> = (props) => {",
      "  return (",
      "    <div>TODO</div>",
      "  );",
      "}",
    }),
  }
  local callback = {
    t("const "),
    i(1),
    t({
      " = React.useCallback(() => {",
    }),
    t({
      "", "}, [])",
    })
  }
  ls.add_snippets('typescriptreact', {
    s('makeRequest', makeRequest),
    s('fc', fcReact),
    s('cb', callback),
  })
end

function module.setup(luasnip)
  if not luasnip then
    return
  end
  luasnip.setup()
  add_snippets(luasnip)
end

return module
