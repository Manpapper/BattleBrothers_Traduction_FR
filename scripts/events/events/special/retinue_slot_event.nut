this.retinue_slot_event <- this.inherit("scripts/events/event", {
	m = {
		LastSlotsUnlocked = 0
	},
	function create()
	{
		this.m.ID = "event.retinue_slot";
		this.m.Title = "Along the way...";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Le prestige et la renommée de %companyname% ne cessent de croître. Partout où vous allez, des gens cherchent à vous rejoindre - et pas seulement des mercenaires, mais des adeptes qui peuvent être d\'une autre utilité ! | A chaque bataille de vos mercenaires, la renommée de la compagnie grandit. Au fur et à mesure que cette renommée augmente, de plus en plus de personnes, et pas seulement des mercenaires, chercheront à rejoindre  %companyname%. Peut-être est-il temps que la compagnie prenne un autre compagnon non-combattant ? | Les compagnons de %companyname% ne doivent pas être uniquement des combattants - il semble qu\'avec la renommée et le prestige croissants de la compagnie, d\'autres personnes soient prêtes à suivre le mouvement. Ces compagnons pourraient être d\'une grande utilité pour la compagnie, même s\'ils ne contribuent pas sur le champ de bataille.}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je vais jeter un coup d\'oeil à notre suite !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local unlocked = this.World.Retinue.getNumberOfUnlockedSlots();

		if (unlocked > this.m.LastSlotsUnlocked && this.World.Retinue.getNumberOfCurrentFollowers() < unlocked)
		{
			this.m.Score = 400;
		}
	}

	function onPrepare()
	{
		this.m.LastSlotsUnlocked = this.World.Retinue.getNumberOfUnlockedSlots();
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU8(this.m.LastSlotsUnlocked);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);
		this.m.LastSlotsUnlocked = _in.readU8();
	}

});

