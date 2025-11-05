# Generated from verticals/banking/grammar/Banking_v0_85.g4 by ANTLR 4.13.1
from antlr4 import *
if "." in __name__:
    from .Banking_v0_85Parser import Banking_v0_85Parser
else:
    from Banking_v0_85Parser import Banking_v0_85Parser

# This class defines a complete generic visitor for a parse tree produced by Banking_v0_85Parser.

class Banking_v0_85Visitor(ParseTreeVisitor):

    # Visit a parse tree produced by Banking_v0_85Parser#eblDefinition.
    def visitEblDefinition(self, ctx:Banking_v0_85Parser.EblDefinitionContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#metadata.
    def visitMetadata(self, ctx:Banking_v0_85Parser.MetadataContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#metadataField.
    def visitMetadataField(self, ctx:Banking_v0_85Parser.MetadataFieldContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#dataObject.
    def visitDataObject(self, ctx:Banking_v0_85Parser.DataObjectContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#fieldDef.
    def visitFieldDef(self, ctx:Banking_v0_85Parser.FieldDefContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#policyDef.
    def visitPolicyDef(self, ctx:Banking_v0_85Parser.PolicyDefContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#resourceBlock.
    def visitResourceBlock(self, ctx:Banking_v0_85Parser.ResourceBlockContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#resourceDef.
    def visitResourceDef(self, ctx:Banking_v0_85Parser.ResourceDefContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#entity.
    def visitEntity(self, ctx:Banking_v0_85Parser.EntityContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#property.
    def visitProperty(self, ctx:Banking_v0_85Parser.PropertyContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#propertyDef.
    def visitPropertyDef(self, ctx:Banking_v0_85Parser.PropertyDefContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#propertyAttr.
    def visitPropertyAttr(self, ctx:Banking_v0_85Parser.PropertyAttrContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#ruleStatement.
    def visitRuleStatement(self, ctx:Banking_v0_85Parser.RuleStatementContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#itAsset.
    def visitItAsset(self, ctx:Banking_v0_85Parser.ItAssetContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#kvPair.
    def visitKvPair(self, ctx:Banking_v0_85Parser.KvPairContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#relRef.
    def visitRelRef(self, ctx:Banking_v0_85Parser.RelRefContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#relationshipDef.
    def visitRelationshipDef(self, ctx:Banking_v0_85Parser.RelationshipDefContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#process.
    def visitProcess(self, ctx:Banking_v0_85Parser.ProcessContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#step.
    def visitStep(self, ctx:Banking_v0_85Parser.StepContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#inputItem.
    def visitInputItem(self, ctx:Banking_v0_85Parser.InputItemContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#validation.
    def visitValidation(self, ctx:Banking_v0_85Parser.ValidationContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#action.
    def visitAction(self, ctx:Banking_v0_85Parser.ActionContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#errorAction.
    def visitErrorAction(self, ctx:Banking_v0_85Parser.ErrorActionContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#output.
    def visitOutput(self, ctx:Banking_v0_85Parser.OutputContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#typeDef.
    def visitTypeDef(self, ctx:Banking_v0_85Parser.TypeDefContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#event.
    def visitEvent(self, ctx:Banking_v0_85Parser.EventContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#ruleDef.
    def visitRuleDef(self, ctx:Banking_v0_85Parser.RuleDefContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#report.
    def visitReport(self, ctx:Banking_v0_85Parser.ReportContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#integration.
    def visitIntegration(self, ctx:Banking_v0_85Parser.IntegrationContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#operation.
    def visitOperation(self, ctx:Banking_v0_85Parser.OperationContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#type.
    def visitType(self, ctx:Banking_v0_85Parser.TypeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#fieldAttr.
    def visitFieldAttr(self, ctx:Banking_v0_85Parser.FieldAttrContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by Banking_v0_85Parser#value.
    def visitValue(self, ctx:Banking_v0_85Parser.ValueContext):
        return self.visitChildren(ctx)



del Banking_v0_85Parser