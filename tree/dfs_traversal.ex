defmodule Tree do
    defstruct [:left, :right, :root]
end



defmodule MatchNullTraverse do
    require Tree

    defmacro __using__(_) do
        Enum.map ~w(preorder inorder postorder), fn func ->
            quote do
                def unquote(:"#{func}")(%Tree{root: nil}), do: []
                def unquote(:"#{func}")(%Tree{root: root, left: nil, right: nil}), do: [root]

                case unquote(:"#{func}") do
                    :preorder ->
                        def unquote(:"#{func}")(%Tree{root: root, left: nil, right: %Tree{}=right}) do
                            [root] ++ unquote(:"#{func}")(right)
                        end
                        def unquote(:"#{func}")(%Tree{root: root, right: nil, left: %Tree{}=left}) do
                            [root] ++ unquote(:"#{func}")(left)
                        end 
                    :inorder ->
                        def unquote(:"#{func}")(%Tree{root: root, left: nil, right: %Tree{}=right}) do
                            [root] ++ unquote(:"#{func}")(right)
                        end
                        def unquote(:"#{func}")(%Tree{root: root, right: nil, left: %Tree{}=left}) do
                            unquote(:"#{func}")(left) ++ [root]
                        end
                    :postorder ->
                        def unquote(:"#{func}")(%Tree{root: root, left: nil, right: %Tree{}=right}) do
                            unquote(:"#{func}")(right) ++ [root]
                        end
                        def unquote(:"#{func}")(%Tree{root: root, right: nil, left: %Tree{}=left}) do
                            unquote(:"#{func}")(left) ++ [root]
                        end
                end
            end
            # |> Macro.expand_once(__ENV__) |> Macro.to_string |> IO.puts
        end
    end
end


defmodule TraverseTree do
    use MatchNullTraverse
    
    def preorder(%Tree{root: root, left: left, right: right}) do
        [root] ++ preorder(left) ++ preorder(right)
    end

    def inorder(%Tree{root: root, left: left, right: right}) do
        inorder(left) ++ [root] ++ inorder(right) 
    end

    def postorder(%Tree{root: root, left: left, right: right}) do
        postorder(left) ++ postorder(right) ++ [root]
    end

end

defmodule Test do
    require TraverseTree
    
    def run do
        t = %Tree{root: 4, left: %Tree{root: 2, left: %Tree{root: 1}, right: %Tree{root: 3}}, right: %Tree{root: 5, right: %Tree{root: 6}}}

        IO.inspect TraverseTree.preorder(t)
        IO.inspect TraverseTree.inorder(t)
        IO.inspect TraverseTree.postorder(t)
    end
end

Test.run