this.trade_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		AmountToBuy = 25,
		AmountToSell = 25
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.trade";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Il y a beaucoup de couronnes à gagner avec le commerce entre les villes.\nGagnons une fortune !";
		this.m.UIText = "Acheter et vendre des biens";
		this.m.TooltipText = "Achetez et vendez 25 objets de commerce, comme des fourrures, du sel ou des épices. C\'est en les achetant dans les petits villages qui les produisent et en les vendant dans les grandes villes que vous gagnerez le plus d\'argent. Certains produits commerciaux sont également exclusifs à certaines régions, comme les déserts du sud, et les vendre dans d\'autres parties du monde peut encore augmenter votre marge.";
		this.m.SuccessText = "[img]gfx/ui/events/event_55.png[/img]La pensée vous envahit dès le début, et c\'est une pensée qui échappe à beaucoup de capitaines mercenaires. Une idée si simple que peut-être sa simplicité même la camoufle à l\'ego d\'un leader maniant l\'épée. Si %companyname% doit voyager de ville en ville à la recherche de travail, on peut déjà avoir un pied dans une toute autre vocation : celle du commerce. Vous avez vite compris que les marchandises ont une valeur différente de celle qui apparaît à première vue, une valeur cachée à l\'œil nu, et cachée dans les fluctuations du temps et de l\'espace. Maintenant, vous passez des soirées à vous battre pour compter les couronnes. Pour une fois, c\'est un bon problème à avoir.";
		this.m.SuccessButtonText = "C\'est l\'essentiel.";
	}

	function getUIText()
	{
		local bought = 25 - (this.m.AmountToBuy - this.World.Statistics.getFlags().getAsInt("TradeGoodsBought"));
		local sold = 25 - (this.m.AmountToSell - this.World.Statistics.getFlags().getAsInt("TradeGoodsSold"));
		local d = this.Math.min(25, this.Math.min(bought, sold));
		return this.m.UIText + " (" + d + "/25)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1 && this.World.Assets.getOrigin().getID() != "scenario.trader")
		{
			return;
		}

		this.m.AmountToBuy = this.World.Statistics.getFlags().getAsInt("TradeGoodsBought") + 25;
		this.m.AmountToSell = this.World.Statistics.getFlags().getAsInt("TradeGoodsSold") + 25;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("TradeGoodsBought") >= this.m.AmountToBuy && this.World.Statistics.getFlags().getAsInt("TradeGoodsSold") >= this.m.AmountToSell)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU32(this.m.AmountToBuy);
		_out.writeU32(this.m.AmountToSell);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 63)
		{
			this.m.AmountToBuy = _in.readU32();
			this.m.AmountToSell = _in.readU32();
		}
	}

});

