this.cultist_origin_finale_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Sacrifice = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_finale";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]%cultist% entre dans votre tente, un vent fort et frais le poursuit, soulevant vos parchemins et autres notes. Il s\'avance, les mains croisées devant lui, un air assez solennel dans sa démarche.%SPEECH_ON%Monsieur, on est venu me parlr, c\'est une affaire grave dont on m\'a confié la responsabilité.%SPEECH_OFF%Vous levez la main et dites à l\'homme de se taire. Avec précaution, vous prenez chaque bougie de la tente et les éteignez jusqu\'à ce qu\'il en reste une. Vous la portez à votre visage...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Parle-moi, Davkul.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]Agenouillé devant la bougie, vous tenez votre main au-dessus de la flamme et celle-ci s\'immobilise, pointant vers le haut sans bouger. Vous avez vu des glaçons plus animés que ça. Vous fixez la lueur et la tente fond, glissant dans les plis d\'une obscurité immense et immuable. Le cultistes est parti. A sa place se trouve une cape noire, ses bras jusqu\'à vos épaules, une ardoise de granit pour tête, ses bords ébréchés et craquelés. Il semble qu\'il y ait quelque chose derrière ce masque, derrière cet effort futile pour protéger votre esprit de son vrai visage. Vous tendez la main vers le masque, mais une force invisible vous en empêche.%SPEECH_ON%En temps voulu, vous verrez tout ce que je suis.%SPEECH_OFF%La voix est puissante mais se réduit à un murmure brutal que vous seul pouvez entendre.%SPEECH_ON%Je vous donne la Mort, mortel, elle sera à son aise et visitée par vos ennemis. %sacrifice% ne sera pas perdu, il sera toujours avec vous, je vous le promets.%SPEECH_OFF%Une blancheur s\'abat sur vous, un coup de vent, les volets de la tente se replient vers l\'extérieur, la flamme de la bougie s\'incline de façon incroyable sans s\'éteindre, et une fraîcheur glaciale qui fait que votre premier souffle flotte dans l\'air. %cultist% est introuvable. Vous vous levez rapidement et vous vous touchez le visage et la peau, comme pour s\'assurer que tout est bien à sa place. A votre grande déception, Davkul est parti et vous êtes toujours le même.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le sacrifice doit être fait.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Absolument pas!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]Davkul serait très mécontent de votre manque d\'obéissance, bien que vous ne ressentiez aucune envie de faire autre chose que ce qui est demandé. Vous et %cultistes% allez à la tente du %sacrifice%. Il se penche comme s\'il vous attendait déjà et voit le couteau dans le chariot de votre groupe, il hoche la tête à sa simple vue. %cultist% s\'agenouille à côté de l\'homme, vous réalisez qu\'ils ont déjà parlé auparavant, que la question qui vous a été posée pourrait très bien avoir été un test de votre dévotion envers Davkul. Vous êtes heureux d\'avoir réussi.\n\n%sacrifice% déboutonne sa chemise et %cultist% pénètre sa poitrine comme s\'il mettait une clé dans une serrure, il se permet même de la tourner. Le sacrifié halète et se crispe, car aucune dévotion à Davkul ne peut mettre de côté la manière dont la mort est permise, c\'est-à-dire dans la douleur et la souffrance. Mais il sourit, et la lumière ne s\'éteint pas tant de ses yeux, une certaine obscurité, que vous n\'aviez jamais vue auparavant, les remplace. Il est parti.\n\n %cultist% se met au travail sur le cadavre encore chaud, découpant la chair en tranches et faisant résonner ses coups lorsqu\'il frappe les tendons. Il sépare le buste. Un brouillard noir accompagne les moindres mouvements de la lame, elle semble se balancer joyeusement après chacun de ses mouvements. Lorsque %cultist% a terminé, %sacrifice% a été transformé en une plaque d\'armure, de la chair déchirée et étirée, des dents pour les rivets, des tendons pour les sangles, des os pour les pauldrons, un carnage absolu. La plaque palpite et bouge comme si elle vivait encore.%cultist% se tourne vers vous, ses mains sont rouges.%SPEECH_ON%Davkul nous attend tous.%SPEECH_OFF%Vous hochez la tête et embrassez votre camarade.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est fait, c\'est bon.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sacrifice.getImagePath());
				local dead = _event.m.Sacrifice;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Sacrificed to Davkul",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Sacrifice.getName() + " has died"
				});
				_event.m.Sacrifice.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(_event.m.Sacrifice);
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/armor/legendary/armor_of_davkul");
				item.m.Description = "Un aspect sinistre de Davkul, une ancienne puissance non originaire de ce monde, et les derniers vestiges de " + _event.m.Sacrifice.getName() + " à partir duquel il a été façonné. Il ne se brisera jamais, mais continuera plutôt à faire repousser sa peau cicatrisée sur place.";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez the " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.improveMood(2.0, "Appeased Davkul");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else
					{
						bro.worsenMood(3.0, "Horrified by the death of " + _event.m.Sacrifice.getName());

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous sentez que c\'est un test. Pas un test à passer en sacrifiant un de vos hommes, mais plutôt le contraire. Davkul a peut-être envoyé des faux croyants pour voir si vous feriez tout ce qu\'ils disaient... simplement parce qu\'ils le disaient. Vous ne savez que vous devez suivre votre instinct. Au moment où vous vous apprêtez à annoncer votre décision à %cultist%, la moitié des bougies de la pièce s\'éteignent soudainement. Des volutes de fumée flottent dans l\'obscurité restante, un brouillard sinueux à travers lequel, pendant un instant, vous jurez voir un visage noirci disparaître par l\'ouverture de la tente. Vous avez l\'impression que %cultist% sait déjà quel choix vous avez fait. Vous restez dans la tente et attendez la présence de Davkul. Lorsqu\'on ne ressent rien, on rallume simplement les bougies et on parle à une pièce vide.%SPEECH_ON%Davkul nous attend tous.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et avec lui, l\'obscurité.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.worsenMood(2.0, "Was denied the chance to appease Davkul");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 150)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 12)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local sacrifice_candidates = [];
		local cultist_candidates = [];
		local bestCultist;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultist_candidates.push(bro);

				if ((bestCultist == null || bro.getLevel() > bestCultist.getLevel()) && bro.getBackground().getID() == "background.cultist")
				{
					bestCultist = bro;
				}

				if (bro.getLevel() >= 11)
				{
					sacrifice_candidates.push(bro);
				}
			}
		}

		if (cultist_candidates.len() <= 5 || bestCultist == null || bestCultist.getLevel() < 11 || sacrifice_candidates.len() < 2)
		{
			return;
		}

		for( local i = 0; i < sacrifice_candidates.len(); i = ++i )
		{
			if (bestCultist.getID() == sacrifice_candidates[i].getID())
			{
				sacrifice_candidates.remove(i);
				break;
			}
		}

		this.m.Cultist = bestCultist;
		this.m.Sacrifice = sacrifice_candidates[this.Math.rand(0, sacrifice_candidates.len() - 1)];
		this.m.Score = cultist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist.getName()
		]);
		_vars.push([
			"sacrifice",
			this.m.Sacrifice.getName()
		]);
		_vars.push([
			"sacrifice_short",
			this.m.Sacrifice.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.Sacrifice = null;
	}

});

