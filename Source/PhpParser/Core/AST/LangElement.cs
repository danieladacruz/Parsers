using System;
using PHP.Syntax;
using PHP.Core.Text;

namespace PHP.Core.AST
{
    public interface IAstNode
    {

    }

    /// <summary>
    /// Base class for all AST nodes.
    /// </summary>
    public abstract class AstNode : IAstNode, IPropertyCollection
    {
        #region Fields & Properties

        /// <summary>
        /// Contains properties of this <see cref="AstNode"/>.
        /// </summary>
        private PropertyCollection _properties;

        /// <summary>
        /// Gets property collection associated with this node.
        /// </summary>
        public IPropertyCollection Properties { get { return (IPropertyCollection)this; } }

        #endregion

        #region IPropertyCollection

        void IPropertyCollection.SetProperty(object key, object value)
        {
            _properties.SetProperty(key, value);
        }

        object IPropertyCollection.GetProperty(object key)
        {
            return _properties.GetProperty(key);
        }

        public void SetProperty<T>(T value)
        {
            _properties.SetProperty<T>(value);
        }

        public T GetProperty<T>()
        {
            return _properties.GetProperty<T>();
        }

        bool IPropertyCollection.TryGetProperty(object key, out object value)
        {
            return _properties.TryGetProperty(key, out value);
        }

        bool IPropertyCollection.TryGetProperty<T>(out T value)
        {
            return _properties.TryGetProperty<T>(out value);
        }

        bool IPropertyCollection.RemoveProperty(object key)
        {
            return _properties.RemoveProperty(key);
        }

        bool IPropertyCollection.RemoveProperty<T>()
        {
            return _properties.RemoveProperty<T>();
        }

        void IPropertyCollection.ClearProperties()
        {
            _properties.ClearProperties();
        }

        object IPropertyCollection.this[object key]
        {
            get
            {
                return _properties.GetProperty(key);
            }
            set
            {
                _properties.SetProperty(key, value);
            }
        }

        #endregion
    }

    /// <summary>
	/// Base class for all AST nodes representing PHP language Elements - statements and expressions.
	/// </summary>
	public abstract class LangElement : AstNode
	{
		/// <summary>
		/// Position of element in source file.
		/// </summary>
        public Span Span { get; protected set; }
		
		/// <summary>
        /// Initialize the LangElement.
        /// </summary>
        /// <param name="span">The position of the LangElement in the source code.</param>
		protected LangElement(Span span)
		{
			this.Span = span;
		}

        /// <summary>
        /// In derived classes, calls Visit* on the given visitor object.
        /// </summary>
        /// <param name="visitor">Visitor.</param>
        public abstract void VisitMe(TreeVisitor/*!*/visitor);
	}

    #region VariableNode

    /// <summary>
    /// Represents a variable name and its position within AST.
    /// </summary>
    public struct VariableNode // : AstNode
    {
        private readonly Span _span;
        private readonly VariableName _name;

        /// <summary>
        /// Position of the name.
        /// </summary>
        public Span Span => _span;

        /// <summary>
        /// Variable name.
        /// </summary>
        public VariableName Name => _name;

        public VariableNode(Span span, string name)
            : this(span, new VariableName(name))
        {
        }

        public VariableNode(Span span, VariableName name)
        {
            _span = span;
            _name = name;
        }
    }

    #endregion

    #region Scope

    public struct Scope
    {
        public int Start { get { return start; } }
        private int start;

        public static readonly Scope Invalid = new Scope(-1);
        public static readonly Scope Global = new Scope(0);
        public static readonly Scope Ignore = new Scope(Int32.MaxValue);

        public bool IsGlobal
        {
            get
            {
                return start == 0;
            }
        }

        public bool IsValid
        {
            get
            {
                return start >= 0;
            }
        }

        public Scope(int start)
        {
            this.start = start;
        }

        public void Increment()
        {
            start++;
        }

        public override string ToString()
        {
            return start.ToString();
        }
    }

    #endregion

    #region IDeclarationElement

    public interface IDeclarationElement
    {
        /// <summary>
        /// Gets extent of entire declaration including header, modifiers, attributes and eventually function body.
        /// </summary>
        Text.Span EntireDeclarationSpan { get; }
    }

    #endregion

    #region IHasSourceUnit

    /// <summary>
    /// Annotates AST nodes having reference to containing source unit.
    /// </summary>
    public interface IHasSourceUnit
    {
        /// <summary>
        /// Gets source unit of the containing source file.
        /// </summary>
        SourceUnit SourceUnit { get; }
    }

    #endregion
}