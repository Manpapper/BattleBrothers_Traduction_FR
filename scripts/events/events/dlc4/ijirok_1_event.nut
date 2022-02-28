this.ijirok_1_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ijirok_1";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]%randombrother% vous appelle et dit qu'il y a quelque chose que vous devriez venir voir. Il y a sûrement quelque chose qui vaut la peine d'être vu dans toute cette glace et ce néant.\n\n Le mercenaire vous amène à un trou caverneux dans le sol. Il allume une torche et y entre et vous suivez. Là, au fond, vous trouvez quelques autres de vos hommes. Ils sont debout autour de ce qui ressemble à un sarcophage fait de glace, sauf qu'il n'y a pas de couvercle. Une noirceur gelée recouvre les bords du conteneur. Dans le coin de la pièce se trouve un cadavre glacé collé au mur. Ses mains sont à ses côtés et des stalactites de sang coulent de ses poignets. À côté de lui, une paire de vêtements est suspendue à des crochets de glace, mais aucun corps n'y est attaché. Une traînée de sang mène des vêtements à l'autre homme, puis ressort de la grotte.%SPEECH_ON%Je ne sais pas quoi faire de ça monsieur.%SPEECH_OFF%Dit un mercenaire. Vous demandez aux hommes s'ils ont vu quelque chose pendant leurs recherches, et vous voulez dire presque n'importe quoi. Mais ils secouent tous la tête, non. Si quelque chose était dans cette boîte, il est sûrement sorti maintenant. Vous dites aux hommes de sortir de la grotte et de retourner au camp.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et gardez vos esprits.",
					function getResult( _event )
					{
						this.World.Flags.set("IjirokStage", 1);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (!this.World.Flags.has("IjirokStage") || this.World.Flags.get("IjirokStage") >= 5)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 10)
			{
				return;
			}
		}

		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

