this.cultist_finale_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Sacrifice = null
	},
	function create()
	{
		this.m.ID = "event.cultist_finale";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]%cultist% entre dans votre tente et un vent fort et vif le poursuit, soulevant vos parchemins et autres notes. Il s\'avance, les mains croisées devant lui, avec un air plutôt religieux dans sa démarche.%SPEECH_ON%Monsieur, on m\'a parlé et c\'est une affaire grave dont on m\'a confié la responsabilité.%SPEECH_OFF%Vous demandez à l\'homme de qui il est en train de parler. Le cultiste se penche en avant comme si les mots pesaient sur sa langue.%SPEECH_ON%Davkul, Monsieur.%SPEECH_OFF%Ah, bien sûr, qui d\'autre ? Vous dites à l\'homme d\'expliquer ce dont il a besoin. L\'homme répond.%SPEECH_ON%Non, pas moi, Davkul. C\'est Davkul qui est dans le besoin, et il a besoin de sang, d\'un sacrifice.%SPEECH_OFF%Vous dites à l\'homme que la compagnie peut s\'arrêter à la prochaine ville pour acheter des poulets, des agneaux ou tout ce dont il a besoin si c\'est si important. %cultist% secoue la tête.%SPEECH_ON%Le sang d\'une bête impie ? Non, il exige le sang d\'un guerrier. Un véritable esprit de combat et il m\'a fait confiance pour trouver un homme de cette importance - et je l\'ai fait.%SPEECH_OFF%Le cultistes se redresse, la lumière de la bougie de la tente est soudainement inconstante et irrégulière.%SPEECH_ON%Davkul demande le sang de %sacrifice%.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et si que ce passe-t-il que je sois ou non d\'accord avec cette folie ?",
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
			Text = "[img]gfx/ui/events/event_33.png[/img]En s\'approchant d\'une bougie vacillante, %cultist% place sa main au-dessus de la flamme et le feu s\'immobilise, pointant vers le haut et sans bouger. Vous avez vu des glaçons plus animés que ça. Il parle en fixant la lueur.%SPEECH_ON%Si nous faisons cela, Davkul sera très heureux. Sinon, eh bien, nous verrons. Je ne sais même pas ce qui pourrait se passer.%SPEECH_OFF%Vous dites au cultiste s\'il vous demande de tuer un de vos hommes, il devra faire mieux que ça. En entendant cela, il s\'approche et vous attrape par les épaules. La tente disparaît, glissant dans les plis d\'une obscurité immense et immuable. Le cultistes a disparu. A sa place se trouve une cape noire, ses bras jusqu\'à vos épaules, une ardoise de granit en guise de tête, ses bords ébréchés et craquelés. Il semble qu\'il y ait quelque chose derrière ce masque, derrière cet effort futile pour protéger votre esprit de son véritable visage. Une voix parle, une voix gutturale et puissante qui se réduit à un murmure brutal que vous êtes le seul à entendre.%SPEECH_ON%Je te donnerai la Mort, mortel, et réchauffés dans ses conforts, la Mort sera visitée par tes ennemis. %sacrifice% ne sera pas perdu, il sera toujours avec toi, je te le promets.%SPEECH_OFF%Une blancheur s\'abat sur vous, un coup de vent, les tissus de la tente se recourbent vers l\'extérieur, les flammes des bougies s\'inclinent de façon impossible sans s\'éteindre, et une fraîcheur glaciale qui fait que votre premier souffle flotte dans l\'air. %cultist% n\'est nulle part. Vous vous levez rapidement et vous touchez votre visage et votre peau, pour vous assurer que vous êtes bien ce que vous êtes censé être. La vision demeure cependant, et son empreinte pulsante a laissé derrière elle une réalité macabre : ce que le cultist a suggéré est quelque chose à prendre au sérieux.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faites ce qui doit être fait.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Absolument pas !",
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
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous décidez de succomber à l\'impression indéniable que Davkul serait très mécontent de votre manque d\'obéissance. Mais %sacrifice% a également mérité un mot de départ de votre part. Vous éclaircissant le visage, vous sortez de votre tente et allez parler à l\'homme. Peut-être que le simple fait d\'entendre sa voix vous ramènera à la raison avant que vous ne vous jetiez du haut de la corniche dans un vide insensé d\'où cet acte a probablement émané.\n\nLorsque vous arrivez à sa tente, vous remarquez que son tissu est déjà ouvert et qu\'il ondule doucement dans le vent. Vous pénétrez à l\'intérieur et trouvez le mercenaire au lit, sa couverture jetée sur lui. Vous prenez place, prononcez quelques mots, en espérant au fond de vous qu\'il se réveille.%SPEECH_ON%Tu as été bon, %sacrifice_short%, mieux que ce que j\'aurais pu le demander. Un vrai frère de %companyname% et le genre de combattant que tout capitaine serait fier d\'avoir.\n\nHé, ne me laisse pas divaguer ici. Je sais que tu es réveillé, espèce de rustre.%SPEECH_OFF%Vous tendez la main vers la couverture et la tirez en arrière. Vous sautez sur vos pieds et manquez de renverser la tente. Dans le lit ne se trouve pas %sacrifice%, mais un torse, sa chair déchirée et tendue autour d\'une armure faite d\'un métal inconnu, des dents pour les rivets, des tendons pour les sangles, des os pour les pauldrons, une cuirasse de carnage absolu. %cultist% se tient dans l\'ouverture de la tente.%SPEECH_ON%Davkul est très heureux et nous a gratifiés d\'un aspect de la Mort.%SPEECH_OFF%Ce... ce n\'est pas ce à quoi vous vous attendiez. Vous ne savez même pas à quoi vous vous attendiez, mais cela n\'aurait jamais pu être imaginé ou préparé. Ce qui est fait est fait, et que l\'âme de %sacrifice% repose en paix. Il est peu probable que vous le soyez un jour.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pouvu que les vieux dieux ne me regardent pas en cette nuit.",
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
					KilledBy = "Saccrifié à Davkul",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Sacrifice.getName() + " est mort"
				});
				_event.m.Sacrifice.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Sacrifice.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Sacrifice);
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/armor/legendary/armor_of_davkul");
				item.m.Description = "Un aspect macabre de Davkul, une ancienne puissance qui n\'est pas de ce monde, et les derniers vestiges de" + _event.m.Sacrifice.getName() + " à partir duquel il a été façonné. Il ne se brisera jamais, mais continuera à repousser sa peau cicatrisée sur place.";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.improveMood(2.0, "A appaisé Davkul");

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
						bro.worsenMood(3.0, "Horrifié par la mort de " + _event.m.Sacrifice.getName());

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
			Text = "[img]gfx/ui/events/event_33.png[/img]Malgré l\'horreur dont vous venez d\'être témoin, vous décidez que %sacrifice% doit vivre. Au moment où vous vous apprêtez à aller annoncer la nouvelle à %cultist%, la moitié des bougies de la pièce s\'éteignent soudainement. Des volutes de fumée s\'élèvent, une brume tordue à travers laquelle, pendant un instant, vous jurez avoir vu un visage dur et furieux se transformer et disparaître. Vous avez l\'impression que %cultist% sait déjà quel choix vous avez fait. Vous restez dans la tente et rallumez les bougies.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quelque part sur la route, cette compagnie a pris un mauvais tournant.",
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
						bro.worsenMood(2.0, "On lui a refusé la chance d\'apaiser Davkul");

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
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 200)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.cultists")
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
			}
			else if (bro.getLevel() >= 11 && !bro.getSkills().hasSkill("trait.player") && !bro.getFlags().get("IsPlayerCharacter") && !bro.getFlags().get("IsPlayerCharacter"))
			{
				sacrifice_candidates.push(bro);
			}
		}

		if (cultist_candidates.len() <= 5 || bestCultist == null || bestCultist.getLevel() < 11 || sacrifice_candidates.len() == 0)
		{
			return;
		}

		this.m.Cultist = bestCultist;
		this.m.Sacrifice = sacrifice_candidates[this.Math.rand(0, sacrifice_candidates.len() - 1)];
		this.m.Score = 3;
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

