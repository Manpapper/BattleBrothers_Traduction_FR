this.tundra_elk_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.tundra_elk_destroyed";
		this.m.Title = "Après le combat...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_146.png[/img]{Le coup fatal étant bien porté, l\'Ijirok grimpe d\'un côté à l\'autre en serrant sa dernière blessure. Il laisse échapper un hurlement de douleur, ses genoux se plient et peut à peine se tenir d\'une main tandis que son corps se déforme, il vomit sur le sol. Mais tout cela ressemble à une mascarade, la bête regarde parfois par-dessus comme pour s\'assurer que vous regardez. C\'est du théâtre. Un spectacle mal joué pour ceux qui connaissent la mort. Les yeux se fixent sur les vôtres et son sourire inquiétant réapparaît, puis la monstruosité émet un flash bleu aveuglant et, lorsque la lumière naturelle du monde revient, le corps est gelé, des flocons de neige tombent du ciel.\n\n Ça ne peut pas être ça. Vous le savez. Vous vous approchez des restes gelés et commencez à couper. Quand vous taillez dans la glace, une sueur bleue s\'écoule des canaux et des trous. Un dernier coup brise la glace et une masse gluante coule dans tous les sens. Alors que les hommes regardent d\'un air plutôt inquiet, vous saisissez l\'armure brisée de la grotte et la jetez dans le sang de l\'Ijirok. Les étranges vrilles qui maintenaient les pièces ensemble s\'éclaircissent instantanément et vous observez qu\'elles commencent à se tordre et à tirer les plaques ensemble. La fourrure d\'élan emmêlée s\'associe au métal comme s\'il s\'agissait d\'un seul et même être venant guérir de vieilles blessures. Le sang serpente sur les plaques comme la mousse qui virevolte sous le lit d\'une rivière, s\'enroulant dans tous les sens avant de s\'aplatir et de peindre l\'armure d\'un rouge éclatant. \n\nEn le ramassant, vous sentez un bourdonnement au bout de vos doigts.%SPEECH_ON%J\'espère que vous ne me suggérez pas de porter ça, capitaine.%SPEECH_OFF%dit %randombrother%, en secouant la tête avec un sourire nerveux. Vous ne savez pas encore de quoi l\'armure est capable, mais vous avez sans doute l\'intention de la garder dans votre inventaire pour voir. Quant à l\'Ijirok, vous n\'avez aucun doute qu\'il est toujours là quelque part. Son cadavre se décompose déjà rapidement et les os qui restent ne sont pas ceux d\'une bête géante mais simplement ceux d\'un pauvre élan.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pourtant, nous avons gagné.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IjirokStage", 5);
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.broken_ritual_armor")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Vous perdez " + item.getName()
						});
						break;
					}
				}

				this.World.Assets.getStash().makeEmptySlots(2);
				local item = this.new("scripts/items/helmets/legendary/ijirok_helmet");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				local item = this.new("scripts/items/armor/legendary/ijirok_armor");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_146.png[/img]{Le coup fatal étant bien porté, l\'Ijirok grimpe d\'un côté à l\'autre en serrant sa dernière blessure. Il laisse échapper un hurlement de douleur, ses genoux se plient et peut à peine se tenir d\\'une main tandis que son corps se déforme, il vomit sur le sol. Mais tout cela ressemble à une mascarade, la bête regarde parfois par-dessus comme pour s\\'assurer que vous regardez. C\\'est du théâtre. Un spectacle mal joué pour ceux qui connaissent la mort. Les yeux se fixent sur les vôtres et son sourire inquiétant réapparaît, puis la monstruosité émet un flash bleu aveuglant et, lorsque la lumière naturelle du monde revient, le corps est gelé, des flocons de neige tombent du ciel.\n\n Ça ne peut pas être ça. Vous le savez. Vous vous approchez des restes gelés et commencez à couper. Quand vous taillez dans la glace, une sueur bleue s\\'écoule des canaux et des trous. Un dernier coup brise la glace et une masse gluante coule dans tous les sens.\n\nVous n\'avez aucun doute que cette chose est toujours là quelque part. Son cadavre se décompose déjà rapidement et les os qui restent ne sont pas ceux d\'une bête géante mais simplement ceux d\'un pauvre élan.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pourtant, nous avons gagné.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IjirokStage", 5);
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		local stash = this.World.Assets.getStash().getItems();

		foreach( i, item in stash )
		{
			if (item != null && item.getID() == "misc.broken_ritual_armor")
			{
				return "A";
			}
		}

		return "B";
	}

	function onClear()
	{
	}

});

