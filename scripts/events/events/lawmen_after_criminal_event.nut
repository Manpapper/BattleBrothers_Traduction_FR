this.lawmen_after_criminal_event <- this.inherit("scripts/events/event", {
	m = {
		Criminal = null,
		OtherBro = null,
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.lawmen_after_criminal";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_90.png[/img]Des cavaliers franchissent la crête d\'une colline voisine, leurs silhouettes sombres et bizarrement formées sur son bord comme un récif de noir ondulant. N\'étant pas totalement capable de voir qui ils sont, vous ordonnez à quelques-uns de vos confrères de se cacher. Une embuscade pourrait être nécessaire pour vous défendre, sinon vous n\'avez aucune chance contre une telle force montée. Alors que les mercenaires sélectionnés s\'enfoncent dans les buissons, les cavaliers commencent à descendre la colline. Le tonnerre des sabots se fait plus fort, mais vous restez résolu, espérant donner à vos hommes une belle démonstration de bravoure.\n\nVous voyez que le porte-bannière porte un sigle de %noblehousename%. Derrière lui, un autre cavalier traîne un traîneau avec quelques hommes enchaînés comme chargement. Lorsque les hommes arrivent, leur chef se dresse sur les garrots de son cheval et vous désigne avant de parler.%SPEECH_ON%Mercenaire ! Nous avons par l\'autorité du seigneur le droit de réclamer les - enchaînés ! - donnez-nous %criminal%. Cet homme est parmi vous. Il doit payer pour ses crimes. Livrez-le immédiatement et vous serez récompensé.%SPEECH_OFF% Vous tournez la tête et crachez. Vous faites un signe de tête à l\'homme de loi avant de lui poser une question.%SPEECH_ON%Et de quelle autorité disposez-vous ? Il y a beaucoup de seigneurs dans ces terres et tous ne me paient pas bien.%SPEECH_OFF%Le chef se rassied sur sa selle. Ses mains se croisent sur son pommeau, s\'y posant avec une autorité imperturbable. Il n\'a pas l\'air amusé et exprime ainsi son mécontentement.%SPEECH_ON%La punition pour avoir délibérément hébergé un fugitif est la mort. Vous n\'avez plus qu\'une seule chance de me rendre ce criminel ou vous connaîtrez un sort bien adapté à un chien de mercenaire.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "La compagnie ne ferait que souffrir si nous nous battions pour ça. L\'homme est à vous.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nous ne l\'abandonnerons pas.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.getMoney() >= 1500)
				{
					this.Options.push({
						Text = "Ce n\'est pas quelque chose qui ne peut pas être résolu avec une grosse bourse de couronnes ?",
						function getResult( _event )
						{
							return "F";
						}

					});
				}

				if (this.World.Assets.getBusinessReputation() > 3000)
				{
					this.Options.push({
						Text = "Vous savez qui vous menacez ? %companyname% !",
						function getResult( _event )
						{
							return "G";
						}

					});
				}
				else
				{
					this.Options.push({
						Text = "Vous avez un dessin de l\'homme que vous recherchez ? Laissez-moi y jeter un coup d\'oeil.",
						function getResult( _event )
						{
							return this.Math.rand(1, 100) <= 50 ? "D" : "E";
						}

					});
				}

				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_53.png[/img]Vous n\'avez aucune chance contre ces hommes. Bien que cela vous fasse très mal, vous livrez %criminal%. Il vous aboie des injures pendant que les hommes de loi l\'enchaînent, et traine votre nom dans la boue pendant qu\'ils le jettent avec le reste des hommes attachés. Le capitaine des hommes de loi se dirige vers vous au trot sur son cheval. Il ricane avant de jeter une bourse de pièces sur le sol. Son corps est proche et il y a une ouverture dans son armure. Vous pourriez y glisser un couteau, juste entre les côtes, et conduire la lame jusqu\'à son coeur. Ce serait rapide. Mais vous ne tiendriez pas longtemps après, et tous vos hommes seraient rapidement tués. Au lieu de cela, vous vous penchez et ramassez les pièces, ravalez votre fierté, et dites merci. Les hommes de loi ne perdent pas de temps pour retourner d\'où ils viennent.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Je ne peux pas mettre toute la compagnie en jeu pour toi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/asset_brothers.png",
					text = _event.m.Criminal.getName() + " a quitté la compagnie"
				});
				_event.m.Criminal.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(_event.m.Criminal);
				this.World.Assets.addMoney(100);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + 100 + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_10.png[/img]Alors que l\'homme de loi vous regarde, attendant une réponse, vous émettez un sifflement aigu. La moitié de la compagnie émerge des buissons, poussant des cris et des hurlements en guise d\'embuscade. Le cheval qui tire le traineau fait ruer son cavalier au sol avant de partir en trombe, avec un groupe de criminels aux yeux écarquillés qui l\'accompagnent. Un autre homme de loi bat en retraite, abandonnant sa troupe. Un mercenaire arrache un homme de sa selle tandis qu\'un autre enfonce une lance dans la poitrine d\'un cheval, faisant s\'écraser au sol la bête et l\'homme. Le capitaine tombe de son cheval quand celui-ci se cabre dans une peur sauvage. La chute est rude, mais il parvient à se remettre sur ses pieds, et le cheval qui se cabre le frappe à la tête. C\'est une mort rapide et brutale qui laisse le capitaine face contre terre dans le cercueil de son propre casque. Le reste de ses hommes vient se placer près de son corps et vous regarde avec la vengeance dans les yeux.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Chargez!",
					function getResult( _event )
					{
						_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Vous avez tué certains de leurs hommes");
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.NobleTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.TemporaryEnemies = [
							_event.m.NobleHouse.getID()
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Noble, this.Math.rand(80, 100) * _event.getReputationToDifficultyLightMult(), _event.m.NobleHouse.getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_78.png[/img]Le capitaine des hommes de loi fait claquer ses doigts à l\'un des porte-étendards. Celui-ci lui remet un parchemin que le capitaine déplie avant de vous le remettre. L\'homme que vous voyez ressemble remarquablement à %criminal%, mais depuis que vous êtes sur la route, le mercenaire a gagné quelques cicatrices qui séparent son visage de celui sur le papier. Mais ils ne vous croiront pas. Alors vous mentez à la place.%SPEECH_ON%L\'homme que vous recherchez est mort. C\'était un criminel, comme vous l\'avez dit, et nous l\'avons trouvé en train de voler nos aliments. %other_bro% l\'a transpercé d\'une épée quand on l\'a découvert.%SPEECH_OFF% %other_bro% te regarde, puis les hommes de loi. Il hoche la tête.%SPEECH_ON% C\'est ce que j\'ai fait. Il avait la bouche pleine de mon pain quand je l\'ai planté comme un porc ! J\'ai gardé le reste du pain pour moi, Dieu merci.%SPEECH_OFF% Les hommes de loi gloussent entre eux. Leur capitaine les regarde en arrière, son regard les calmes en un instant. Il se tourne vers vous. Vous comprenez pourquoi ils se taisent : ses yeux sont sévères, immobiles, féroces, noirs. L\'homme vous tient dans ce regard pendant près d\'une demi-minute avant de hocher la tête et de rassembler ses rênes.%SPEECH_ON%D\'accord, mercenaire. Merci de nous avoir prévenus.%SPEECH_OFF%Les hommes de loi remballent et repartent d\'où ils sont venus. Un soupir de soulagement passe dans toute la compagnie et vous ordonnez aux hommes cachés dans les buissons de sortir. La route est encore longue et vous espèrez qu\'il n\'y aura pas d\'autres problèmes comme celui-ci.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Ouf.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
				_event.m.Criminal.improveMood(2.0, "A était protégé par la compagnie.");

				if (_event.m.Criminal.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Criminal.getMoodState()],
						text = _event.m.Criminal.getName() + this.Const.MoodStateEvent[_event.m.Criminal.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_78.png[/img]Le capitaine vous tend un parchemin avec le visage de %criminal% dessus. C\'est vrai, la ressemblance est là. Mais l\'homme est dans votre compagnie depuis assez longtemps pour avoir une cicatrice ou deux. Peut-être n\'ont-ils pas réalisé que c\'était lui ? Vous demandez au criminel de s\'avancer et, nerveusement, il s\'exécute. Vous regardez le capitaine. %SPEECH_ON%Est-ce l\'homme que vous recherchez ? Je comprends pourquoi vous pensez que c\'est lui, mais regardez ces cicatrices. L\'homme du dessin n\'en a aucune. Et regardez ses cheveux ! Ceux du dessin sont raides, alors que ceux de cet homme sont clairement emmêlés et bouclés.%SPEECH_OFF% Vous arrêtez parce qu\'à en juger par les visages de votre public, ce n\'est même pas près de fonctionner. Le capitaine tire son épée.%SPEECH_ON%Vous me prenez pour un idiot ? Tuez-les tous.%SPEECH_OFF%Eh bien, tant pis pour ça. Avant que les hommes de loi puissent charger, vous sifflez aussi fort que possible. La moitié de la compagnie sort des buissons en hurlant comme des fous. La frayeur soudaine rend les chevaux sauvages, jetant leurs cavaliers dans la boue, et le tireur de traineau s\'enfuit même, emportant avec lui un couple de criminels très confus.\n\n%randombrother% traverse le champ de bataille, une lance à la main. Il la plante profondément dans le destrier du capitaine, faisant s\'écraser l\'homme et la bête au sol. Les hommes de loi, ou ce qu\'il en reste, se rassemblent autour de leur capitaine. Semblant grogner, l\'homme essuie le sang de son visage et crache une dent. Il esquisse un sourire béat avant d\'ordonner à ses hommes de charger.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Formez les rangs !",
					function getResult( _event )
					{
						_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Vous avez tué certains de leurs hommes");
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.NobleTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.TemporaryEnemies = [
							_event.m.NobleHouse.getID()
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Noble, this.Math.rand(80, 100) * _event.getReputationToDifficultyLightMult(), _event.m.NobleHouse.getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_04.png[/img]Les menaces du capitaine se refroidissent lorsque vous récupérez une grande sacoche de couronnes. Ses hommes échangent des regards lorsque vous leur montrez la sacoche.%SPEECH_ON%Nous n\'avons pas le temps pour ça. Ce que j\'ai là, c\'est %bribe% couronnes. Prenez-les et partez. Restez, et gagnez une tombe. Votre choix, homme de loi.%SPEECH_OFF% Sentant les regards de ses compagnons de route, le capitaine est particulièrement prudent dans sa réflexion. Il évalue vos hommes, et fait brièvement de même pour les siens. Il doit constater de grandes pertes car il finit par hocher la tête. Tirant sur la bride de son cheval, il fait avancer sa monture et vous vous retrouvez tous les deux face à face. Vous souriez en remettant les couronnes.%SPEECH_ON%Dépensez-les bien.%SPEECH_OFF%Le capitaine prend la sacoche et l\'attache sur le côté de sa selle, passant le harnais de cuir sur la poignée d\'une épée sous le regard de ses hommes. Il hoche la tête, mais ne sourit pas en retour.%SPEECH_ON%Ma fille doit se marier dans une quinzaine de jours. J\'aimerais y être vivant.%SPEECH_OFF% Vous hochez la tête et faites vos adieux au capitaine sans humour.%SPEECH_ON%Que son mari soit bon, et ses enfants nombreux.%SPEECH_OFF%Le capitaine fait avancer son cheval et le ramène à ses hommes. Ils partent, les sabots de leurs montures s\'enfonçant dans le lointain jusqu\'à ce qu\'il n\'y ait plus que le bruissement de l\'herbe soulevée par le vent pour remplir l\'air.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Ce que je ne fais pas pour vous...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
				this.World.Assets.addMoney(-1000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + 1000 + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_12.png[/img]Vous marchez directement vers le capitaine, vous arrêtant à mi-chemin entre vos hommes et les siens. Les poings sur les hanches, vous appelez les hommes de loi du capitaine, leur demandant s\'ils connaissent le nom de %companyname%. Vous voyez quelques-uns des cavaliers se redresser sur leurs selles, faisant tenir en équilibre les bras tendus sur leurs arçons tout en regardant attentivement votre bannière. Ils se rasseoient rapidement et des murmures étouffés descendent et remontent le long de leur ligne de bataille.\n\n Un homme demande si c\'est vrai que vous tondez le nez de ceux que vous tuez. Ce n\'est pas vrai, mais vous n\'avez aucune raison de dire la vérité. Un autre homme demande si %randombrother% est dans vos rangs, et s\'il a un collier d\'oreilles et mange de la farine d\'os au petit déjeuner. Vous étouffez l\'envie de rire et vous vous contentez de hocher la tête. Tout naturellement, les rumeurs gagnent vos adversaires et ils commencent à crier que ce combat n\'est pas le leur.\n\n Le capitaine leur dit que vous racontez des conneries et de charger, mais aucun ne suit ses ordres. Finalement, le capitaine est forcé de faire demi-tour, et de poursuivre ses hommes qui sont maintenant en retraite.\n\n Le supposé frère cannibale s\'approche, en se grattant la tête. %SPEECH_ON%De la farine d\'os pour le petit déjeuner?%SPEECH_OFF%Un grésillement de rire parcourt la compagnie et bientôt un chant de \"Ne me mange pas\" est entonné.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Ne défiez pas %companyname% !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		if (this.World.getTime().Days < 30 && this.World.Assets.getOrigin().getID() == "scenario.raiders")
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.FactionManager.isGreaterEvil())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.18)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		if (brothers.len() < 2)
		{
			return;
		}

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.killer_on_the_run" || bro.getBackground().getID() == "background.thief" || bro.getBackground().getID() == "background.graverobber" || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.nomad")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = this.getNearestNobleHouse(this.World.State.getPlayer().getTile());

		if (this.m.NobleHouse == null)
		{
			return;
		}

		this.m.Criminal = candidates[this.Math.rand(0, candidates.len() - 1)];

		do
		{
			this.m.OtherBro = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
		while (this.m.OtherBro == null || this.m.OtherBro.getID() == this.m.Criminal.getID());

		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"criminal",
			this.m.Criminal.getName()
		]);
		_vars.push([
			"other_bro",
			this.m.OtherBro.getName()
		]);
		_vars.push([
			"noblehousename",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"bribe",
			"1000"
		]);
	}

	function onClear()
	{
		this.m.Criminal = null;
		this.m.OtherBro = null;
		this.m.NobleHouse = null;
	}

});

